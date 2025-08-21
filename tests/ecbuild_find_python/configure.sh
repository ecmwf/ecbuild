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

# Ensure Python 3.x is available
if [[ "$(type -t module)" == "function" ]];
then
  # "module()" is available when running on HPC
  python3 --version
fi

# --------------------- cleanup ------------------------
$SOURCE/clean.sh

# ----------------- configure project ---------------------

TC=1
mkdir -p $HERE/build_${TC}
ecbuild $SOURCE/interpreter_and_libs_project -B $HERE/build_${TC} | tee $HERE/build_${TC}.log
EXPECT_ONE_OF $HERE/build_${TC}.log "Build files have been written"

TC=2
mkdir -p $HERE/build_${TC}
ecbuild $SOURCE/interpreter_and_libs_with_version_project -B $HERE/build_${TC} | tee $HERE/build_${TC}.log
EXPECT_ONE_OF $HERE/build_${TC}.log "Build files have been written"

TC=3
mkdir -p $HERE/build_${TC}
ecbuild $SOURCE/interpreter_only_project -B $HERE/build_${TC} | tee $HERE/build_${TC}.log
EXPECT_ONE_OF $HERE/build_${TC}.log "Build files have been written"

TC=4
mkdir -p $HERE/build_${TC}
ecbuild $SOURCE/interpreter_only_with_version_project -B $HERE/build_${TC} | tee $HERE/build_${TC}.log
EXPECT_ONE_OF $HERE/build_${TC}.log "Build files have been written"

TC=5
mkdir -p $HERE/build_${TC}
ecbuild $SOURCE/nonexistent_version_project -B $HERE/build_${TC} | tee $HERE/build_${TC}.log
EXPECT_ONE_OF $HERE/build_${TC}.log "Build files have been written"
