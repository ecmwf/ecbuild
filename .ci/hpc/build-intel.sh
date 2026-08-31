#!/bin/bash

#SBATCH --qos=nf
#SBATCH --gres=ssdtmp:10G
#SBATCH --time=00:30:00
#SBATCH --nodes=1
#SBATCH --ntasks=2

module load prgenv/intel-llvm
module unload intel
module load intel/2025.3.1
module load cmake
module load python3/3.13.13-01

cmake -S "$CI_SOURCE_DIR" -B "${TMPDIR:-/tmp}/build" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_C_COMPILER=icx \
  -DCMAKE_CXX_COMPILER=icpx \
  -DCMAKE_INSTALL_PREFIX="$CI_INSTALL_PREFIX" \
  -DENABLE_TESTS=ON
cmake --build "${TMPDIR:-/tmp}/build" --parallel "${SLURM_NTASKS:-8}"
ctest --test-dir "${TMPDIR:-/tmp}/build" --output-on-failure -j "${SLURM_NTASKS:-8}"
cmake --install "${TMPDIR:-/tmp}/build"
