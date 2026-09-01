#!/bin/bash
# This recipe runs no tests!

#SBATCH --qos=nf
#SBATCH --gres=ssdtmp:10G
#SBATCH --time=00:15:00
#SBATCH --nodes=1
#SBATCH --ntasks=2

module load prgenv/nvidia
module unload nvidia
module load nvidia/24.11
module load cmake

cmake -S "$CI_SOURCE_DIR" -B "${TMPDIR:-/tmp}/build" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX="$CI_INSTALL_PREFIX" \
  -DENABLE_TESTS=OFF
cmake --install "${TMPDIR:-/tmp}/build"

# The fetcher takes the artifact from CI_INSTALL_ARCHIVE, not from the install
# tree; .part + mv so it only ever appears complete.
mkdir -p "$(dirname "$CI_INSTALL_ARCHIVE")"
tar -czf "$CI_INSTALL_ARCHIVE.part" -C "$CI_INSTALL_PREFIX" .
mv "$CI_INSTALL_ARCHIVE.part" "$CI_INSTALL_ARCHIVE"
