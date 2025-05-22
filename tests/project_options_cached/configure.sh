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
EXPECT_ONE_OF $HERE/build_1.a.log "Feature FEATUREA disabled"
EXPECT_ONE_OF $HERE/build_1.a.log "Feature FEATUREB enabled"
EXPECT_ONE_OF $HERE/build_1.a.log "Build files have been written"
# Ensure the option values are correct in CMakeCache
EXPECT_ONE_OF $HERE/build_1/CMakeCache.txt "project_ENABLE_FEATUREA_defined_value:INTERNAL=OFF"
EXPECT_ONE_OF $HERE/build_1/CMakeCache.txt "project_ENABLE_FEATUREB_defined_value:INTERNAL=ON"

ecbuild $SOURCE/test_project -B $HERE/build_1 -DENABLE_FEATUREA=ON -DENABLE_FEATUREB=OFF -DECBUILD_LOG_LEVEL=DEBUG | tee $HERE/build_1.b.log
# Ensure the option values are correct in CMake output
EXPECT_ONE_OF $HERE/build_1.b.log "Feature FEATUREA enabled"
EXPECT_ONE_OF $HERE/build_1.b.log "Feature FEATUREB disabled"
EXPECT_ONE_OF $HERE/build_1.b.log "Build files have been written"
# Ensure the option values are correct in CMakeCache
EXPECT_ONE_OF $HERE/build_1/CMakeCache.txt "project_ENABLE_FEATUREA_defined_value:INTERNAL=ON"
EXPECT_ONE_OF $HERE/build_1/CMakeCache.txt "project_ENABLE_FEATUREB_defined_value:INTERNAL=OFF"

ecbuild $SOURCE/test_project -B $HERE/build_1 -DECBUILD_LOG_LEVEL=DEBUG | tee $HERE/build_1.c.log
# Ensure the option values are correct in CMake output
EXPECT_ONE_OF $HERE/build_1.c.log "Feature FEATUREA enabled"
EXPECT_ONE_OF $HERE/build_1.c.log "Feature FEATUREB disabled"
EXPECT_ONE_OF $HERE/build_1.c.log "Build files have been written"
# Ensure the option values are correct in CMakeCache
EXPECT_ONE_OF $HERE/build_1/CMakeCache.txt "project_ENABLE_FEATUREA_defined_value:INTERNAL=ON"
EXPECT_ONE_OF $HERE/build_1/CMakeCache.txt "project_ENABLE_FEATUREB_defined_value:INTERNAL=OFF"

ecbuild $SOURCE/test_project -B $HERE/build_1 -DENABLE_FEATUREA=OFF -DENABLE_FEATUREB=ON -DECBUILD_LOG_LEVEL=DEBUG | tee $HERE/build_1.d.log
# Ensure the option values are correct in CMake output
EXPECT_ONE_OF $HERE/build_1.d.log "Feature FEATUREA disabled"
EXPECT_ONE_OF $HERE/build_1.d.log "Feature FEATUREB enabled"
EXPECT_ONE_OF $HERE/build_1.d.log "Build files have been written"
# Ensure the option values are correct in CMakeCache
EXPECT_ONE_OF $HERE/build_1/CMakeCache.txt "project_ENABLE_FEATUREA_defined_value:INTERNAL=OFF"
EXPECT_ONE_OF $HERE/build_1/CMakeCache.txt "project_ENABLE_FEATUREB_defined_value:INTERNAL=ON"

ecbuild $SOURCE/test_project -B $HERE/build_1 -DECBUILD_LOG_LEVEL=DEBUG | tee $HERE/build_1.e.log
EXPECT_ONE_OF $HERE/build_1.e.log "Feature FEATUREA disabled"
EXPECT_ONE_OF $HERE/build_1.e.log "Feature FEATUREB enabled"
EXPECT_ONE_OF $HERE/build_1.e.log "Build files have been written"
# Ensure the option values are correct in CMakeCache
EXPECT_ONE_OF $HERE/build_1/CMakeCache.txt "project_ENABLE_FEATUREA_defined_value:INTERNAL=OFF"
EXPECT_ONE_OF $HERE/build_1/CMakeCache.txt "project_ENABLE_FEATUREB_defined_value:INTERNAL=ON"
