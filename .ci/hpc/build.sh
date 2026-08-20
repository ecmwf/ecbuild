#!/bin/bash
# ecbuild's HPC build recipe, submitted as a SLURM job by build-on-hpc.
#
# ecbuild is a compiler-independent collection of CMake modules: there is nothing
# to compile, only an install. ci-infrastructure wraps this file (it waits for
# the source transfer, unpacks into node-local $TMPDIR and cds there, exports
# $CI_INSTALL_PREFIX, appends the sentinel), so this script owns only its #SBATCH
# resources, module loads and the install — and must NOT print "Finished: ...".

# atos (hpc2020) selects on QoS rather than partition; ssdtmp sizes the
# node-local SSD behind $TMPDIR. Plain #SBATCH lines: we submit through troika's
# site API, which does not read its "# troika key=value" directives.
#SBATCH --qos=nf
#SBATCH --gres=ssdtmp:10G
#SBATCH --time=00:15:00
#SBATCH --nodes=1
#SBATCH --ntasks=2

module load prgenv/gnu
module load cmake

cmake -S "$CI_SOURCE_DIR" -B "${TMPDIR:-/tmp}/build" \
  -DCMAKE_INSTALL_PREFIX="$CI_INSTALL_PREFIX" \
  -DENABLE_TESTS=OFF
cmake --install "${TMPDIR:-/tmp}/build"
