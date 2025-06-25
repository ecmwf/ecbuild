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

# (1) Configure with default options, and then reconfigure with user specified options

mkdir -p $HERE/build_1
ecbuild $SOURCE/test_project -B $HERE/build_1 -DECBUILD_LOG_LEVEL=DEBUG | tee $HERE/build_1.a.log
# Ensure the option values are correct in CMake output
EXPECT_ONE_OF $HERE/build_1.a.log "FEATUREA.*proja(ON): ''"
EXPECT_ONE_OF $HERE/build_1.a.log "FEATUREA.*projb(OFF): ''"
EXPECT_ONE_OF $HERE/build_1.a.log "FEATUREB.*proja(ON): ''" # Uses value specified at 'bundle' level
EXPECT_ONE_OF $HERE/build_1.a.log "FEATUREB.*projb(ON): ''"
EXPECT_ONE_OF $HERE/build_1.a.log "FEATUREC.*proja(OFF): ''"  # Uses value specified at 'bundle' level
EXPECT_ONE_OF $HERE/build_1.a.log "FEATUREC.*projb(OFF): ''"
EXPECT_ONE_OF $HERE/build_1.a.log "Build files have been written"

ecbuild $SOURCE/test_project -B $HERE/build_1 -DENABLE_FEATUREA=ON -DENABLE_FEATUREB=OFF -DECBUILD_LOG_LEVEL=DEBUG | tee $HERE/build_1.b.log
# Ensure the option values are correct in CMake output
EXPECT_ONE_OF $HERE/build_1.b.log "FEATUREA.*proja(ON): ''"
EXPECT_ONE_OF $HERE/build_1.b.log "FEATUREA.*projb(ON): ''"
EXPECT_ONE_OF $HERE/build_1.b.log "FEATUREB.*proja(OFF): ''"  # Uses value specified by 'CLI'
EXPECT_ONE_OF $HERE/build_1.b.log "FEATUREB.*projb(OFF): ''"
EXPECT_ONE_OF $HERE/build_1.b.log "FEATUREC.*proja(OFF): ''"  # Uses value specified at 'bundle' level
EXPECT_ONE_OF $HERE/build_1.b.log "FEATUREC.*projb(OFF): ''"
EXPECT_ONE_OF $HERE/build_1.b.log "Build files have been written"
