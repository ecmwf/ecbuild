#!/usr/bin/env bash

set -euo pipefail

ECBUILD_PATH=${CMAKE_SOURCE_DIR}/bin
SOURCE_TEST_DIR=${CMAKE_CURRENT_SOURCE_DIR}
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
rm -rf "${BINARY_TEST_DIR}/workspace-shallow-only"

WORKSPACE="${BINARY_TEST_DIR}/workspace-shallow-only"
BUNDLE_DIR="${WORKSPACE}/bundle"

# ---- setup umbrella project (with submodules) --------
cd "${BINARY_TEST_DIR}"
bash "${SOURCE_TEST_DIR}/setup-umbrella-project.sh" "${WORKSPACE}/projects"

BARE_DIR="${WORKSPACE}/bare-repos"
UMBRELLA_GIT="file://${BARE_DIR}/umbrella.git"

# ---- create bundle: SHALLOW only (no RECURSIVE) ------
mkdir -p "${BUNDLE_DIR}"
cat > "${BUNDLE_DIR}/CMakeLists.txt" <<EOF
cmake_minimum_required(VERSION 3.18 FATAL_ERROR)
find_package( ecbuild 3.12 REQUIRED HINTS ${CMAKE_SOURCE_DIR} )
project( umbrella-bundle LANGUAGES NONE )
ecbuild_bundle_initialize()
ecbuild_bundle(
  PROJECT umbrella
  GIT "${UMBRELLA_GIT}"
  BRANCH main
  SHALLOW
)
ecbuild_bundle_finalize()
EOF

cat > "${BUNDLE_DIR}/VERSION" <<EOF
0.0.1
EOF

# ---- configure umbrella bundle -----------------------
mkdir -p "${WORKSPACE}/build"
cd "${WORKSPACE}/build"
ecbuild --prefix="$(pwd)/install" -- "${BUNDLE_DIR}"

# ---- check: umbrella is shallow ----------------------
PASS=1

cd "${BUNDLE_DIR}/umbrella"
if [[ "$(git rev-parse --is-shallow-repository)" != "true" ]]; then
    echo "Umbrella is not shallow: FAIL"
    PASS=0
else
    echo "Umbrella is shallow: PASS"
fi

# ---- check: submodules are NOT initialised -----------
# Without RECURSIVE, ecbuild_git skips the submodule update step; the
# submodule directories should exist (as tracked gitlinks) but must not
# contain an initialised git repo (.git file/dir created by submodule init).
for sub in alpha beta gamma; do
    if [[ -e "${BUNDLE_DIR}/umbrella/${sub}/.git" ]]; then
        echo "Submodule ${sub} is initialised but RECURSIVE was not requested: FAIL"
        PASS=0
    else
        echo "Submodule ${sub} is not initialised: PASS"
    fi
done

exit $(( 1 - PASS ))
