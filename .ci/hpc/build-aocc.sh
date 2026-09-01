#!/bin/bash
# This recipe runs no tests!

#SBATCH --qos=nf
#SBATCH --gres=ssdtmp:10G
#SBATCH --time=00:15:00
#SBATCH --nodes=1
#SBATCH --ntasks=2

module load prgenv/amd
module unload aocc
module load aocc/4.0.0
module load cmake

cmake -S "$CI_SOURCE_DIR" -B "${TMPDIR:-/tmp}/build" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX="$CI_INSTALL_PREFIX" \
  -DENABLE_TESTS=OFF
cmake --install "${TMPDIR:-/tmp}/build"

# The fetcher takes the artifact from CI_INSTALL_ARCHIVE, not from the install
# tree; .part + mv so it only ever appears complete.
mkdir -p "$(dirname "$CI_INSTALL_ARCHIVE")"
tar -cf - -C "$CI_INSTALL_PREFIX" . | zstd -T0 -q -o "$CI_INSTALL_ARCHIVE.part"
mv "$CI_INSTALL_ARCHIVE.part" "$CI_INSTALL_ARCHIVE"
