#!/bin/bash
# ecbuild's HPC build recipe for the intel toolchain, submitted as a SLURM job by
# build-on-hpc.
#
# Exists for ecflow's hpc-atos-intel leg: every consumer resolves its deps at its
# OWN platform slug, so that leg looks for ecbuild-<sha>-hpc-atos-intel-Release.
#
# The install tree is byte-identical to the gnu leg's — ecbuild is a
# compiler-independent collection of CMake modules (compiler-inputs = [], and the
# artifact name carries no compiler). What the toolchain does change is the
# TESTS: the fixture projects compile with whatever prgenv provides, so this leg
# is what proves ecbuild's macros work under intel.
#
# Differs from build-gnu.sh only in the prgenv module and the pinned compilers.
#
# ci-infrastructure wraps this file (it unpacks the transferred source into
# node-local $TMPDIR and cds there, exports $CI_INSTALL_PREFIX, appends the
# sentinel), so this script owns only its #SBATCH resources, module loads, the
# build, the tests and the install — and must NOT print "Finished: ...".

# atos (hpc2020) selects on QoS rather than partition; ssdtmp sizes the
# node-local SSD behind $TMPDIR. Plain #SBATCH lines: troika's site API does not
# read its "# troika key=value" directives.
#SBATCH --qos=nf
#SBATCH --gres=ssdtmp:10G
# The test suite is 46 nested cmake configures run serially, ~6 minutes on a
# laptop; the margin is for scheduler noise.
#SBATCH --time=00:30:00
#SBATCH --nodes=1
#SBATCH --ntasks=2

# prgenv/intel-llvm, NOT prgenv/intel: the latter resolves to IntelLLVM 2021.4.0,
# a different toolchain entirely. It still links, so the mismatch is invisible --
# which is exactly why it is pinned here rather than left to prgenv's default.
module load prgenv/intel-llvm
module unload intel
module load intel/2025.3.1
module load cmake
# test_ecbuild_find_python ecbuild_critical's on PYTHON_FOUND, which needs the
# Development component (headers + libs), not just an interpreter — the compute
# node's stock python has no dev package. Same module ecflow's recipe loads.
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
