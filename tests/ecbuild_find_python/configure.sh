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

mkdir -p $HERE/build_1
ecbuild $SOURCE/interpreter_and_libs_project -B $HERE/build_1| tee $HERE/build_1.log
EXPECT_ONE_OF $HERE/build_1.log "Build files have been written"

mkdir -p $HERE/build_2
ecbuild $SOURCE/interpreter_only_project -B $HERE/build_2 | tee $HERE/build_2.log
EXPECT_ONE_OF $HERE/build_2.log "Build files have been written"

mkdir -p $HERE/build_3
ecbuild $SOURCE/nonexistent_version_project -B $HERE/build_3 | tee $HERE/build_3.log
EXPECT_ONE_OF $HERE/build_3.log "Build files have been written"
