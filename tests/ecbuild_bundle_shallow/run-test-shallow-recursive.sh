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
rm -rf "${BINARY_TEST_DIR}/workspace"

# ---- setup umbrella project (with submodules) --------
cd "${BINARY_TEST_DIR}"
bash "${SOURCE_TEST_DIR}/setup-umbrella-project.sh" \
          "${BINARY_TEST_DIR}/workspace/projects"

# ---- setup umbrella bundle ---------------------------
cd "${BINARY_TEST_DIR}"
bash "${SOURCE_TEST_DIR}/setup-umbrella-bundle.sh" \
          "${BINARY_TEST_DIR}/workspace/bundle" \
          "${BINARY_TEST_DIR}/workspace/projects/umbrella"

# ---- configure umbrella bundle -----------------------
cd ${BINARY_TEST_DIR}/workspace
mkdir build
cd build
ecbuild --prefix=$(pwd)/install -- ../bundle

# ---- check shallowness (umbrella + submodules) -------
PASS=1

cd "${BINARY_TEST_DIR}/workspace/bundle/umbrella"
if [[ "$(git rev-parse --is-shallow-repository)" != "true" ]]; then
    echo "Umbrella is not shallow: FAIL"
    PASS=0
else
    echo "Umbrella is shallow: PASS"
fi

for sub in alpha beta gamma; do
    cd "${BINARY_TEST_DIR}/workspace/bundle/umbrella/${sub}"
    if [[ "$(git rev-parse --is-shallow-repository)" != "true" ]]; then
        echo "Submodule $sub is not shallow: FAIL"
        PASS=0
    else
        echo "Submodule $sub is shallow: PASS"
    fi
done

exit $(( 1 - PASS ))
