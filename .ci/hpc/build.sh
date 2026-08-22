#!/bin/bash
# ecbuild's HPC build recipe, submitted as a SLURM job by build-on-hpc.
#
# ecbuild is a compiler-independent collection of CMake modules: the install
# itself compiles almost nothing, but ENABLE_TESTS=ON adds tests/ and
# regressions/ — 46 ecbuild_add_test(TYPE SCRIPT) cases, each a nested cmake
# configure of a small fixture project — so this recipe builds and ctests before
# installing, exactly as eckit's does. ci-infrastructure wraps this file (it
# waits for the source transfer, unpacks into node-local $TMPDIR and cds there,
# exports $CI_INSTALL_PREFIX, appends the sentinel), so this script owns only its
# #SBATCH resources, module loads, the build, the tests and the install — and
# must NOT print "Finished: ...".

# atos (hpc2020) selects on QoS rather than partition; ssdtmp sizes the
# node-local SSD behind $TMPDIR. Plain #SBATCH lines: we submit through troika's
# site API, which does not read its "# troika key=value" directives.
#SBATCH --qos=nf
#SBATCH --gres=ssdtmp:10G
# 30 minutes, not the 15 an install-only job needed: the test suite is 46 nested
# cmake configures run serially, ~6 minutes on a laptop, and it runs against
# node-local $TMPDIR rather than $SCRATCH so the margin is for scheduler noise
# rather than Lustre.
#SBATCH --time=00:30:00
#SBATCH --nodes=1
#SBATCH --ntasks=2

module load prgenv/gnu
module load cmake
# test_ecbuild_find_python ecbuild_critical's on PYTHON_FOUND, and that needs the
# Development component (headers + libs), not just an interpreter. The compute
# node's stock python is 2.7.18/3.6.8 with no dev package, so without this the
# test fails while the other 47 pass. Same module ecflow's recipe loads.
module load python3/3.13.13-01

cmake -S "$CI_SOURCE_DIR" -B "${TMPDIR:-/tmp}/build" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX="$CI_INSTALL_PREFIX" \
  -DENABLE_TESTS=ON
cmake --build "${TMPDIR:-/tmp}/build" --parallel "${SLURM_NTASKS:-8}"
ctest --test-dir "${TMPDIR:-/tmp}/build" --output-on-failure
cmake --install "${TMPDIR:-/tmp}/build"
