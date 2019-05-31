#!/usr/bin/env bash
HERE="$( cd $( dirname "${BASH_SOURCE[0]}" ) && pwd -P )"
source ${HERE}/build.sh
build lapack_mkl projects/lapack "-DENABLE_MKL=ON"
