#!/usr/bin/env bash

set -euo pipefail

ECBUILD_PATH=${CMAKE_SOURCE_DIR}/bin
BINARY_TEST_DIR=${CMAKE_CURRENT_BINARY_DIR}

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

if echo "${output}" | grep -q "Cannot pass both UPDATE and SHALLOW"; then
    echo "SHALLOW+UPDATE correctly rejected: PASS"
else
    echo "cmake failed but expected error message not found: FAIL"
    echo "${output}"
    exit 1
fi
