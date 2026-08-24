#!/bin/bash
# ecbuild's HPC build recipe for the aocc toolchain, submitted as a SLURM job by
# build-on-hpc.
#
# Exists for the platform slug: ecflow has an atos-hpc-aocc leg, and every consumer
# resolves its deps at its OWN platform, so that leg looks for
# ecbuild-<sha>-atos-hpc-aocc-Release. The install tree is byte-identical to every
# other ecbuild artifact -- compiler-inputs = [] and there is nothing
# compiler-dependent to install.
#
# NO ctest here, deliberately. atos-hpc-aocc mirrors the legacy
# ci-hpc-config.yml's `aocc-4.0.0` platform, whose ctest_options are
# `--version` -- i.e. the old pipeline builds this toolchain and runs no tests
# on it. Our HPC recipes own their own test invocation, so "run no tests" is
# simply the absence of a ctest line; there is no flag to set and nothing to
# disable. ENABLE_TESTS is OFF to match: building fixtures we never run would
# only expose us to an exotic toolchain for no signal.
#
# ci-infrastructure wraps this file (it waits for the source transfer, unpacks
# into node-local $TMPDIR and cds there, exports $CI_INSTALL_PREFIX, appends the
# sentinel), so this script owns only its #SBATCH resources, module loads and the
# install -- and must NOT print "Finished: ...".

#SBATCH --qos=nf
#SBATCH --gres=ssdtmp:10G
#SBATCH --time=00:15:00
#SBATCH --nodes=1
#SBATCH --ntasks=2

# Toolchain per releng/buildit/build.hpc.sh in ecflow, the authoritative list of
# what this cluster actually provides.
module load prgenv/amd
module unload aocc
module load aocc/4.0.0
module load cmake

cmake -S "$CI_SOURCE_DIR" -B "${TMPDIR:-/tmp}/build" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX="$CI_INSTALL_PREFIX" \
  -DENABLE_TESTS=OFF
cmake --install "${TMPDIR:-/tmp}/build"
