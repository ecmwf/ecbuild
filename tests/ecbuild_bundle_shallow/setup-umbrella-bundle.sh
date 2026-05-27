#!/usr/bin/env bash

set -e
set -u
set -o pipefail

# ─────────────────────────────────────────────
# Configuration
# ─────────────────────────────────────────────
BASE_DIR="${1:-$(pwd)/bundle}"
UMBRELLA_DIR="${2:-$(pwd)/projects/umbrella}"

echo "==> Creating bundle workspace at: $BASE_DIR"
mkdir -p "$BASE_DIR"
cd "$BASE_DIR"

# ─────────────────────────────────────────────
# Create the umbrella bundle
# ─────────────────────────────────────────────
cat > CMakeLists.txt <<EOF

cmake_minimum_required(VERSION 3.18 FATAL_ERROR)

find_package( ecbuild 3.12 REQUIRED HINTS ${CMAKE_SOURCE_DIR} )

project( umbrella-bundle LANGUAGES NONE )

ecbuild_bundle_initialize()

ecbuild_bundle(
  PROJECT umbrella
  GIT "${UMBRELLA_DIR}"
  BRANCH main
  RECURSIVE
  SHALLOW
)

ecbuild_bundle_finalize()

EOF

cat > VERSION <<EOF
0.0.1
EOF
