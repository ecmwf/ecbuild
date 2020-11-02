#!/usr/bin/env bash
HERE="$( cd $( dirname "${BASH_SOURCE[0]}" ) && pwd -P )"
source ${HERE}/build.sh
build tcmalloc projects/tcmalloc -DENABLE_TCMALLOC=ON
