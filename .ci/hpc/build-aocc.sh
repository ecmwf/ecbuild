#!/bin/bash
# ecbuild's HPC build recipe for the aocc toolchain, submitted as a SLURM job by
# build-on-hpc.
#
# Exists for the platform slug: ecflow has an hpc-atos-aocc leg, and every
# consumer resolves its deps at its OWN platform, so that leg looks for
# ecbuild-<sha>-hpc-atos-aocc-Release. The install tree is byte-identical to
# every other ecbuild artifact — compiler-inputs = [] and there is nothing
# compiler-dependent to install.
#
# No ctest: hpc-atos-aocc mirrors the legacy ci-hpc-config.yml's `aocc-4.0.0`
# platform, which builds this toolchain and runs no tests on it. ENABLE_TESTS is
# OFF to match — building fixtures we never run buys no signal.
#
# ci-infrastructure wraps this file (it unpacks the transferred source into
# node-local $TMPDIR and cds there, exports $CI_INSTALL_PREFIX, appends the
# sentinel), so this script owns only its #SBATCH resources, module loads and the
# install — and must NOT print "Finished: ...".

#SBATCH --qos=nf
#SBATCH --gres=ssdtmp:10G
#SBATCH --time=00:15:00
#SBATCH --nodes=1
#SBATCH --ntasks=2

# Toolchain per releng/buildit/build.hpc.sh in ecflow, the authoritative list of
# what this cluster provides.
module load prgenv/amd
module unload aocc
module load aocc/4.0.0
module load cmake

cmake -S "$CI_SOURCE_DIR" -B "${TMPDIR:-/tmp}/build" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX="$CI_INSTALL_PREFIX" \
  -DENABLE_TESTS=OFF
cmake --install "${TMPDIR:-/tmp}/build"
