#!/usr/bin/env bash
HERE="$( cd $( dirname "${BASH_SOURCE[0]}" ) && pwd -P )"
source ${HERE}/build.sh
build cuda projects/cuda
