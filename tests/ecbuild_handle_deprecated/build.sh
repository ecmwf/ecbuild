#!/usr/bin/env bash

set -euo pipefail

SOURCE=${CMAKE_CURRENT_SOURCE_DIR:-"$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd -P )"}

# When not launched by CTest, build in a temporary directory, to avoid polluting the source tree
if [[ -n "${CMAKE_CURRENT_BINARY_DIR:-}" ]]; then
    HERE=${CMAKE_CURRENT_BINARY_DIR}
else
    HERE=$(mktemp -d)
    trap 'rm -rf "${HERE}"' EXIT
fi

# Add ecbuild to path
export PATH="${SOURCE}/../../bin:${PATH}"

# ----------------- CMake version ----------------------

CMAKE_VERSION=$(cmake --version | head -1 | awk '{print $3}')

IFS=. read -r CMAKE_MAJOR_VERSION CMAKE_MINOR_VERSION _ <<< "$CMAKE_VERSION"

# --------------------- cleanup ------------------------
[[ -n "${HERE}" ]] || { echo "error: build directory is not set" >&2; exit 1; }
rm -rf "${HERE}/projectA/build"
rm -rf "${HERE}/projectB/build"

# ----------------- build projectA ---------------------

mkdir -p "${HERE}/projectA/build" && cd "${HERE}/projectA/build"
BUILD_LOG="${HERE}/projectA/build/ecbuild.log"
ecbuild "${SOURCE}/projectA" 2>&1 | tee "${BUILD_LOG}"

if grep -q 'Policy CMP0218 is not set' "${BUILD_LOG}"; then
    echo "error: Unexpected reference to CMP0218 found in '${BUILD_LOG}'" >&2
    exit 1
fi

# ----------------- build projectB ---------------------

if (( CMAKE_MAJOR_VERSION > 4 || (CMAKE_MAJOR_VERSION == 4 && CMAKE_MINOR_VERSION >= 4) )); then

    # This test can only be run if using CMake 4.4+, which actually enforces Policy CMP0218
    #
    # Important: This test will need to be reviewed/removed, if CMake updates its behaviour
    #            and stops producing the deprecation message.

    mkdir -p "${HERE}/projectB/build" && cd "${HERE}/projectB/build"
    BUILD_LOG="${HERE}/projectB/build/ecbuild.log"
    ecbuild "${SOURCE}/projectB" 2>&1 | tee "${BUILD_LOG}"

    if ! grep -q 'Policy CMP0218 is not set' "${BUILD_LOG}"; then
        echo "error: Could not find reference to CMP0218 in '${BUILD_LOG}'" >&2
        exit 1
    fi

else
    echo "Note: skipping projectB (requires CMake 4.4+, found ${CMAKE_VERSION})"
fi
