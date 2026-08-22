#!/bin/bash
# ecbuild's HPC build recipe for the intel toolchain, submitted as a SLURM job by
# build-on-hpc.
#
# Exists because ecflow has an atos-hpc-intel leg and every consumer resolves its
# deps at its OWN platform slug: that leg looks for
# ecbuild-<sha>-atos-hpc-intel-Release, which nothing published, so it failed
# with "Not in the artifact store".
#
# The install tree this produces is byte-identical to the gnu leg's — ecbuild is
# a compiler-independent collection of CMake modules (compiler-inputs = [], and
# the artifact name carries no compiler). Only the platform slug differs, which
# is why this is a separate build rather than a rename. What the toolchain
# actually changes is the TESTS: the fixture projects compile with whatever
# prgenv provides, so this leg is what proves ecbuild's macros work under intel.
#
# Differs from build.sh only in the prgenv module.
#
# ci-infrastructure wraps this file (it waits for the source transfer, unpacks
# into node-local $TMPDIR and cds there, exports $CI_INSTALL_PREFIX, appends the
# sentinel), so this script owns only its #SBATCH resources, module loads, the
# build, the tests and the install — and must NOT print "Finished: ...".

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

module load prgenv/intel
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
