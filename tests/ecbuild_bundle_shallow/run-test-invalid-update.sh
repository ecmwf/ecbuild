#!/usr/bin/env bash

set -euo pipefail

ECBUILD_PATH=${CMAKE_SOURCE_DIR}/bin
BINARY_TEST_DIR=${CMAKE_CURRENT_BINARY_DIR}

#
# Redirect HOME to a per-job temp directory so that every git process
# (including subprocesses spawned internally by git-submodule) reads a private
# ~/.gitconfig. This avoids lock contention on the real ~/.gitconfig when
# parallel CI jobs run, and works on all git versions.
#
# GIT_CONFIG_GLOBAL (requires git >= 2.32) and GIT_CONFIG_COUNT (not forwarded
# by git-submodule to its child processes) are not viable alternatives here.
#
# Required on git >= 2.38.1 and on distros that have backported CVE-2022-39253
# (e.g. Debian 11's git 2.30.2).
#
_tmp_home=$(mktemp -d)
export HOME="${_tmp_home}"
trap 'rm -rf "${_tmp_home}"' EXIT
pushd "${HOME}" > /dev/null
git config --global protocol.file.allow always
git config --global user.name  "Test User"
git config --global user.email "test@user"
popd > /dev/null

# Add ecbuild to path
export PATH=$ECBUILD_PATH:$PATH

# ---- cleanup -----------------------------------------
[[ -n "${BINARY_TEST_DIR}" ]] || { echo "BINARY_TEST_DIR is not set"; exit 1; }
rm -rf "${BINARY_TEST_DIR}/workspace-invalid-update"

WORKSPACE="${BINARY_TEST_DIR}/workspace-invalid-update"
BUNDLE_DIR="${WORKSPACE}/bundle"

# ---- create bundle: SHALLOW + UPDATE (invalid combination) ---
# ecbuild_critical fires before any git operation, so the URL need not exist.
mkdir -p "${BUNDLE_DIR}"
cat > "${BUNDLE_DIR}/CMakeLists.txt" <<EOF
cmake_minimum_required(VERSION 3.18 FATAL_ERROR)
find_package( ecbuild 3.12 REQUIRED HINTS ${CMAKE_SOURCE_DIR} )
project( umbrella-bundle LANGUAGES NONE )
ecbuild_bundle_initialize()
ecbuild_bundle(
  PROJECT umbrella
  GIT "file:///does-not-need-to-exist.git"
  BRANCH main
  SHALLOW
  UPDATE
)
ecbuild_bundle_finalize()
EOF

cat > "${BUNDLE_DIR}/VERSION" <<EOF
0.0.1
EOF

# ---- configure should FAIL with a clear error message --------
mkdir -p "${WORKSPACE}/build"
cd "${WORKSPACE}/build"

set +e
output=$( ecbuild --prefix="$(pwd)/install" -- "${BUNDLE_DIR}" 2>&1 )
cmake_status=$?
set -e

if [[ "${cmake_status}" -eq 0 ]]; then
    echo "cmake configure should have failed for SHALLOW+UPDATE but succeeded: FAIL"
    exit 1
fi

needle="Cannot pass both UPDATE and SHALLOW"

if echo "${output}" | grep -q "${needle}"; then
    echo "SHALLOW+UPDATE correctly rejected: PASS"
else
    echo "cmake failed but expected error message not found: FAIL"

    # ---- diagnostics ---------------------------------------------------
    # This branch has fired on GitHub-hosted ubuntu-24.04 (cmake 3.31.6) while
    # the same commit passes on the self-hosted container (cmake 3.28.3) and on
    # HPC -- and the ${output} printed below visibly CONTAINS the needle. So the
    # first question is which half is lying: is the needle absent from
    # ${output}, or present but not matched through the pipe?
    #
    # The bash `case` answers that outright: no subprocess, no pipe, no locale,
    # no grep. If it says PRESENT while grep says NO MATCH, the message is fine
    # and the plumbing is at fault; the three grep variants below then say which
    # part of the plumbing (SIGPIPE via pipefail, the pipe itself, or grep).
    saved="${WORKSPACE}/captured-output.txt"
    printf '%s' "${output}" > "${saved}"

    case "${output}" in
        *"${needle}"*) echo "DIAG bash-substring : PRESENT" ;;
        *)             echo "DIAG bash-substring : ABSENT"  ;;
    esac
    echo "DIAG output-bytes    : $(wc -c < "${saved}" | tr -d ' ')"
    echo "DIAG saved-to        : ${saved}"

    grep -q "${needle}" "${saved}"      && echo "DIAG grep-file       : MATCH" || echo "DIAG grep-file       : NO MATCH ($?)"
    grep -q "${needle}" <<< "${output}" && echo "DIAG grep-herestring : MATCH" || echo "DIAG grep-herestring : NO MATCH ($?)"
    set +o pipefail
    echo "${output}" | grep -q "${needle}" && echo "DIAG grep-pipe-nopf  : MATCH" || echo "DIAG grep-pipe-nopf  : NO MATCH ($?)"
    set -o pipefail

    echo "DIAG cmake           : $(cmake --version | head -1)"
    echo "DIAG grep            : $(grep --version | head -1)"
    echo "DIAG bash            : ${BASH_VERSION}"
    echo "DIAG locale          : LANG=${LANG:-unset} LC_ALL=${LC_ALL:-unset} LC_CTYPE=${LC_CTYPE:-unset}"

    # The message sits near the end of the capture, so the tail covers it. od
    # shows the real bytes: an invisible separator inside the needle would look
    # perfectly normal in the plain text below.
    echo "DIAG last 800 bytes, as bytes:"
    tail -c 800 "${saved}" | od -c
    # --------------------------------------------------------------------

    echo "${output}"
    exit 1
fi
