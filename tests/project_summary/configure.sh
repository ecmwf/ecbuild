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

# Options: -DENABLE_MYFEATURE=ON

mkdir -p $HERE/build_1
ecbuild -DENABLE_MYFEATURE=ON $SOURCE/test_project -B $HERE/build_1 | tee $HERE/build_1.log
EXPECT_ONE_OF $HERE/build_1.log "* MYFEATURE, proja(✔): '', projb(✔): ''"

# Options: -DENABLE_MYFEATURE=ON -DPROJB_ENABLE_MYFEATURE=OFF

mkdir -p $HERE/build_2
ecbuild -DENABLE_MYFEATURE=ON -DPROJB_ENABLE_MYFEATURE=OFF $SOURCE/test_project -B $HERE/build_2 | tee $HERE/build_2.log
EXPECT_ONE_OF $HERE/build_2.log "* MYFEATURE, proja(✔): '', projb(✘): ''"

# Options: -DENABLE_MYFEATURE=OFF -DPROJB_ENABLE_MYFEATURE=ON
 
mkdir -p $HERE/build_3
ecbuild -DENABLE_MYFEATURE=OFF -DPROJB_ENABLE_MYFEATURE=ON $SOURCE/test_project -B $HERE/build_3 | tee $HERE/build_3.log
EXPECT_ONE_OF $HERE/build_3.log "* MYFEATURE, proja(✘): '', projb(✔): ''"
