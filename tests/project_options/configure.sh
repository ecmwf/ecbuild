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

# (1) Options: (default)

mkdir -p $HERE/build_1
ecbuild $SOURCE/test_project -B $HERE/build_1 | tee $HERE/build_1.log
EXPECT_ONE_OF $HERE/build_1.log "Feature FEATUREON was not enabled"
EXPECT_ONE_OF $HERE/build_1.log "Feature FEATUREOFF disabled"
EXPECT_ONE_OF $HERE/build_1.log "Build files have been written"

# (2) Options: -DENABLE_FEATUREON=ON

mkdir -p $HERE/build_2
ecbuild -DENABLE_FEATUREON=ON $SOURCE/test_project -B $HERE/build_2 | tee $HERE/build_2.log
EXPECT_ONE_OF $HERE/build_2.log "Configuring incomplete, errors occurred!"

# (2a) Options: -DENABLE_FEATUREON=OFF

mkdir -p $HERE/build_2a
ecbuild -DENABLE_FEATUREON=OFF $SOURCE/test_project -B $HERE/build_2a | tee $HERE/build_2a.log
EXPECT_ONE_OF $HERE/build_2a.log "Feature FEATUREON disabled"
EXPECT_ONE_OF $HERE/build_2a.log "Feature FEATUREOFF disabled"
EXPECT_ONE_OF $HERE/build_2a.log "Build files have been written"

# (3) Options: -DENABLE_FEATUREON=ON -DFEATUREON_CONDITION=ON
 
mkdir -p $HERE/build_3
ecbuild -DENABLE_FEATUREON=ON -DFEATUREON_CONDITION=ON $SOURCE/test_project -B $HERE/build_3 | tee $HERE/build_3.log
EXPECT_ONE_OF $HERE/build_3.log "Feature FEATUREON enabled"
EXPECT_ONE_OF $HERE/build_3.log "Feature FEATUREOFF disabled"
EXPECT_ONE_OF $HERE/build_3.log "Build files have been written"

# (4) Options: -DPROJA_ENABLE_FEATUREON=ON

mkdir -p $HERE/build_4
ecbuild -DPROJA_ENABLE_FEATUREON=ON $SOURCE/test_project -B $HERE/build_4 | tee $HERE/build_4.log
EXPECT_ONE_OF $HERE/build_4.log "Configuring incomplete, errors occurred!"

# (4a) Options: -DPROJA_ENABLE_FEATUREON=OFF

mkdir -p $HERE/build_4a
ecbuild -DPROJA_ENABLE_FEATUREON=OFF $SOURCE/test_project -B $HERE/build_4a | tee $HERE/build_4a.log
EXPECT_ONE_OF $HERE/build_4a.log "Feature FEATUREON disabled"
EXPECT_ONE_OF $HERE/build_4a.log "Feature FEATUREOFF disabled"
EXPECT_ONE_OF $HERE/build_4a.log "Build files have been written"

# (5) Options: -DPROJA_ENABLE_FEATUREON=ON -DFEATUREON_CONDITION=ON -DENABLE_FEATUREON=OFF

mkdir -p $HERE/build_5
ecbuild -DPROJA_ENABLE_FEATUREON=ON -DFEATUREON_CONDITION=ON -DENABLE_FEATUREON=OFF $SOURCE/test_project -B $HERE/build_5 | tee $HERE/build_5.log
EXPECT_ONE_OF $HERE/build_5.log "Feature FEATUREON enabled"
EXPECT_ONE_OF $HERE/build_5.log "Feature FEATUREOFF disabled"
EXPECT_ONE_OF $HERE/build_5.log "Build files have been written"

# (6) Options: -DPROJA_ENABLE_FEATUREOFF=ON

mkdir -p $HERE/build_6
ecbuild -DPROJA_ENABLE_FEATUREOFF=ON $SOURCE/test_project -B $HERE/build_6 | tee $HERE/build_6.log
EXPECT_ONE_OF $HERE/build_6.log "Configuring incomplete, errors occurred!"

# (7) Options: -DPROJA_ENABLE_FEATUREOFF=ON -DFEATUREOFF_CONDITION=ON

mkdir -p $HERE/build_7
ecbuild -DPROJA_ENABLE_FEATUREOFF=ON -DFEATUREOFF_CONDITION=ON $SOURCE/test_project -B $HERE/build_7 | tee $HERE/build_7.log
EXPECT_ONE_OF $HERE/build_7.log "Feature FEATUREON was not enabled"
EXPECT_ONE_OF $HERE/build_7.log "Feature FEATUREOFF enabled"
EXPECT_ONE_OF $HERE/build_7.log "Build files have been written"
