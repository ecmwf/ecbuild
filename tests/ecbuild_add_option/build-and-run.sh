#!/usr/bin/env bash

set -e

HERE=${CMAKE_CURRENT_BINARY_DIR:-"$( cd $( dirname "${BASH_SOURCE[0]}" ) && pwd -P )"}
SOURCE=${CMAKE_CURRENT_SOURCE_DIR:-$HERE}

# Add ecbuild to path
export PATH=$SOURCE/../../bin:$PATH
echo $PATH
echo $SOURCE

run_test_ECBUILD_2_COMPAT() {
    local tname=ECBUILD_2_COMPAT__$1
    local exp_sts=$2
    shift 2

    local bdir=$HERE/build_$tname
    local logf=$HERE/$tname.log

    mkdir -p $bdir && cd $bdir
    local sts=0
    echo "Running test '$tname'"
    ecbuild -- -DECBUILD_2_COMPAT=ON -Wno-deprecated $* $SOURCE/test_project >$logf 2>&1 || sts=$?

    if [[ $sts -ne $exp_sts ]] ; then
        echo "Test '$tname': expected exit code $exp_sts, got $sts"
        cat $logf
        exit 1
    fi
}

run_test() {

    run_test_ECBUILD_2_COMPAT "$@"

    local tname=$1
    local exp_sts=$2
    shift 2

    local bdir=$HERE/build_$tname
    local logf=$HERE/$tname.log

    mkdir -p $bdir && cd $bdir
    local sts=0
    echo "Running test '$tname'"
    ecbuild -- -Wno-deprecated $* $SOURCE/test_project >$logf 2>&1 || sts=$?

    if [[ $sts -ne $exp_sts ]] ; then
        echo "Test '$tname': expected exit code $exp_sts, got $sts"
        cat $logf
        exit 1
    fi
}

# --------------------- cleanup ------------------------
$SOURCE/clean.sh

# ---------------------- tests -------------------------
run_test all_def 0 \
    -DEXPECT_TEST_A=ON -DEXPECT_TEST_B=ON -DEXPECT_TEST_C=OFF -DEXPECT_TEST_D=ON -DEXPECT_TEST_E=OFF -DEXPECT_TEST_F=ON -DEXPECT_TEST_G=OFF \
    -DEXPECT_TEST_H=ON -DEXPECT_TEST_I=ON -DEXPECT_TEST_J=OFF -DEXPECT_TEST_K=OFF

run_test all_off 0 \
    -DENABLE_TEST_A=OFF -DENABLE_TEST_B=OFF -DENABLE_TEST_C=OFF -DENABLE_TEST_D=OFF -DENABLE_TEST_E=OFF -DENABLE_TEST_F=OFF -DENABLE_TEST_G=OFF \
    -DEXPECT_TEST_A=OFF -DEXPECT_TEST_B=OFF -DEXPECT_TEST_C=OFF -DEXPECT_TEST_D=OFF -DEXPECT_TEST_E=OFF -DEXPECT_TEST_F=OFF -DEXPECT_TEST_G=OFF \
    -DENABLE_TEST_H=OFF -DENABLE_TEST_I=OFF -DENABLE_TEST_J=OFF -DENABLE_TEST_K=OFF \
    -DEXPECT_TEST_H=OFF -DEXPECT_TEST_I=OFF -DEXPECT_TEST_J=OFF -DEXPECT_TEST_K=OFF

run_test ok_on 0 \
    -DENABLE_TEST_A=ON -DENABLE_TEST_B=ON -DENABLE_TEST_C=ON -DENABLE_TEST_D=ON -DENABLE_TEST_F=ON \
    -DEXPECT_TEST_A=ON -DEXPECT_TEST_B=ON -DEXPECT_TEST_C=ON -DEXPECT_TEST_D=ON -DEXPECT_TEST_F=ON -DEXPECT_TEST_E=OFF -DEXPECT_TEST_G=OFF \
    -DEXPECT_TEST_H=ON -DEXPECT_TEST_I=ON -DEXPECT_TEST_J=OFF -DEXPECT_TEST_K=OFF

run_test fail_pkg_E 1 -DENABLE_TEST_E=ON
run_test fail_cond_G 1 -DENABLE_TEST_G=ON
run_test fail_pkg_J 1 -DENABLE_TEST_J=ON
run_test fail_pkg_K 1 -DENABLE_TEST_K=ON
