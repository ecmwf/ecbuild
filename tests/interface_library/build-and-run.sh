#!/usr/bin/env bash

set -e

HERE=${CMAKE_CURRENT_BINARY_DIR:-"$( cd $( dirname "${BASH_SOURCE[0]}" ) && pwd -P )"}
SOURCE=${CMAKE_CURRENT_SOURCE_DIR:-$HERE}

# Add ecbuild to path
export PATH=$SOURCE/../../bin:$PATH
echo $PATH
echo $SOURCE

run_test() {

    local tname=$1
    local exp_sts=$2
    shift 2

    local bdir=$HERE/build_$tname
    local idir=$HERE/install_$tname
    local logf=$HERE/$tname.log

    mkdir -p $bdir && cd $bdir
    local sts=0
    echo "Running test '$tname'"
    ecbuild --prefix=$idir  -- -Wno-deprecated $* $SOURCE/test_project >$logf 2>&1 || sts=$?

    make install

    if [[ $sts -ne $exp_sts ]] ; then
        echo "Test '$tname': expected exit code $exp_sts, got $sts"
        cat $logf
        exit 1
    fi
}

# --------------------- cleanup ------------------------
$SOURCE/clean.sh

# ---------------------- tests -------------------------
run_test test_interface_library 0
