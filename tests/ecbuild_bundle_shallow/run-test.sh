#!/usr/bin/env bash

set -e
set -x

HERE="$( cd $( dirname "${BASH_SOURCE[0]}" ) && pwd -P )"

ECBUILD_PATH=${CMAKE_SOURCE_DIR}/bin
SOURCE_TEST_DIR=${CMAKE_CURRENT_SOURCE_DIR}
BINARY_TEST_DIR=${CMAKE_CURRENT_BINARY_DIR}

# Git 2.38.1+ blocks local file:// submodule clones by default.
# Allow them for the duration of this script only.
export GIT_CONFIG_COUNT=1
export GIT_CONFIG_KEY_0=protocol.file.allow
export GIT_CONFIG_VALUE_0=always

# Add ecbuild to path
export PATH=$ECBUILD_PATH:$PATH

# ---- cleanup -----------------------------------------
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

# ---- check shallowness (umbrella) --------------------
cd ${BINARY_TEST_DIR}/workspace/bundle/umbrella

if [[ "$(git rev-parse --is-shallow-repository)" == "true" ]]; then
    echo "Submodule is shallow: PASS"
    exit 0
else
    echo "Submodule is not shallow: FAIL"
    exit 1
fi

# ---- check shallowness (umbrella submodules) ---------
for sub in alpha beta gamma; do
    cd "${BINARY_TEST_DIR}/workspace/bundle/umbrella/${sub}"

    if [[ "$(git rev-parse --is-shallow-repository)" == "true" ]]; then
        echo "Submodule $sub is shallow: PASS"
    else
        echo "Submodule $sub is not shallow: FAIL"
        exit 1
    fi
done
