#!/usr/bin/env bash

set -e

function EXPECT_ONE_OF()
{
    local file=$1
    local pattern=$2
    local found=$(cat ${file} | grep "${pattern}" | wc -l | xargs)

    if [ "$found" != "1" ]; then
        echo "File ${file} does not contain exacly one of '$2'"
        exit 1
    fi
}

HERE=${CMAKE_CURRENT_BINARY_DIR:-"$( cd $( dirname "${BASH_SOURCE[0]}" ) && pwd -P )"}
SOURCE=${CMAKE_CURRENT_SOURCE_DIR:-$HERE}

# Add ecbuild to path
export PATH=$SOURCE/../../bin:$PATH
echo $PATH
echo $SOURCE

# --------------------- cleanup ------------------------
$SOURCE/clean.sh

# ----------------- configure project ---------------------

# Options: -DENABLE_FEATURE_A=ON

mkdir -p $HERE/build_1
ecbuild -DENABLE_FEATURE_A=ON $SOURCE/test_project -B $HERE/build_1 | tee $HERE/build_1.log
EXPECT_ONE_OF $HERE/build_1.log "* FEATURE_A, proja(ON): '', projb(ON): ''"

# Options: -DENABLE_FEATURE_A=ON -DPROJB_ENABLE_FEATURE_A=OFF

mkdir -p $HERE/build_2
ecbuild -DENABLE_FEATURE_A=ON -DPROJB_ENABLE_FEATURE_A=OFF $SOURCE/test_project -B $HERE/build_2 | tee $HERE/build_2.log
EXPECT_ONE_OF $HERE/build_2.log "* FEATURE_A, proja(ON): '', projb(OFF): ''"

# Options: -DENABLE_FEATURE_A=OFF -DPROJB_ENABLE_FEATURE_A=ON -DSOME_PACKAGE_FOUND=OFF
 
mkdir -p $HERE/build_3
ecbuild -DENABLE_FEATURE_A=OFF -DPROJB_ENABLE_FEATURE_A=ON -DSOME_PACKAGE_FOUND=OFF $SOURCE/test_project -B $HERE/build_3 | tee $HERE/build_3.log
EXPECT_ONE_OF $HERE/build_3.log "* FEATURE_A, proja(OFF): '', projb(ON): ''"
EXPECT_ONE_OF $HERE/build_3.log "* FEATURE_B, projb(OFF): ''"

# Options: -DENABLE_FEATURE_A=OFF -DPROJB_ENABLE_FEATURE_A=ON -DSOME_PACKAGE_FOUND=ON
 
mkdir -p $HERE/build_4
ecbuild -DENABLE_FEATURE_A=OFF -DPROJB_ENABLE_FEATURE_A=ON -DSOME_PACKAGE_FOUND=ON $SOURCE/test_project -B $HERE/build_4 | tee $HERE/build_4.log
EXPECT_ONE_OF $HERE/build_4.log "* FEATURE_A, proja(OFF): '', projb(ON): ''"
EXPECT_ONE_OF $HERE/build_4.log "* FEATURE_B, projb(ON): ''"

# Options: -DENABLE_FEATURE_A=OFF -DPROJB_ENABLE_FEATURE_A=ON -DENABLE_FEATURE_B=ON -DSOME_PACKAGE_FOUND=ON
 
mkdir -p $HERE/build_5
ecbuild -DENABLE_FEATURE_A=OFF -DPROJB_ENABLE_FEATURE_A=ON -DENABLE_FEATURE_B=ON -DSOME_PACKAGE_FOUND=ON $SOURCE/test_project -B $HERE/build_5 | tee $HERE/build_5.log
EXPECT_ONE_OF $HERE/build_5.log "* FEATURE_A, proja(OFF): '', projb(ON): ''"
EXPECT_ONE_OF $HERE/build_5.log "* FEATURE_B, projb(ON): ''"

# Options: -DENABLE_FEATURE_A=OFF -DPROJB_ENABLE_FEATURE_A=ON -DENABLE_FEATURE_B=ON -DSOME_PACKAGE_FOUND=OFF
 
mkdir -p $HERE/build_6
ecbuild -DENABLE_FEATURE_A=OFF -DPROJB_ENABLE_FEATURE_A=ON -DENABLE_FEATURE_B=ON -DSOME_PACKAGE_FOUND=OFF $SOURCE/test_project -B $HERE/build_6 | tee $HERE/build_6.log
EXPECT_ONE_OF $HERE/build_6.log "Configuring incomplete, errors occurred!"
