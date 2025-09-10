#!/usr/bin/env bash

set -e

function EXPECT_ONE_OF()
{
    local file=$1
    local pattern=$2
    local found=$(cat ${file} | grep -e "${pattern}" | wc -l | xargs)

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

# (0) Options: (default)
#      proja, FEATURE_A is enabled (by default)
#      projb, FEATURE_A is disabled (by default)

TC=0

mkdir -p $HERE/build_${TC}
ecbuild $SOURCE/projx -B $HERE/build_${TC} | tee $HERE/build_${TC}.log
EXPECT_ONE_OF $HERE/build_${TC}.log "FEATURE_A, .*proja(ON): ''.*"
EXPECT_ONE_OF $HERE/build_${TC}.log "FEATURE_A, .*projb(OFF): ''.*"
EXPECT_ONE_OF $HERE/build_${TC}.log "Build files have been written"

# (1) Options: -DSOME_PACKAGE_FOUND
#      proja, FEATURE_A is enabled (by default)
#      projb, FEATURE_A is disabled (by default), event if the conditional package is found

TC=1

mkdir -p $HERE/build_${TC}
ecbuild $SOURCE/projx -DSOME_PACKAGE_FOUND=ON -B $HERE/build_${TC} | tee $HERE/build_${TC}.log
EXPECT_ONE_OF $HERE/build_${TC}.log "FEATURE_A, .*proja(ON): ''.*"
EXPECT_ONE_OF $HERE/build_${TC}.log "FEATURE_A, .*projb(OFF): ''.*"
EXPECT_ONE_OF $HERE/build_${TC}.log "Build files have been written"

# (2) Options: -DENABLE_FEATURE_A=ON
#      proja, FEATURE_A is explicitly enabled (by global option)
#      projb, FEATURE_A is explicitly enabled (by global option), but fails since the conditional package is not found

TC=2

mkdir -p $HERE/build_${TC}
ecbuild $SOURCE/projx -DENABLE_FEATURE_A=ON -B $HERE/build_${TC} | tee $HERE/build_${TC}.log
EXPECT_ONE_OF $HERE/build_${TC}.log " Configuring incomplete, errors occurred"

# (3) Options: -DENABLE_FEATURE_A=ON -DSOME_PACKAGE_FOUND=ON
#      proja, FEATURE_A is explicitly enabled (by global option)
#      projb, FEATURE_A is explicitly enabled (by global option), and succeeds because the conditional package is found

TC=3

mkdir -p $HERE/build_${TC}
ecbuild $SOURCE/projx -DENABLE_FEATURE_A=ON -DSOME_PACKAGE_FOUND=ON -B $HERE/build_${TC} | tee $HERE/build_${TC}.log
EXPECT_ONE_OF $HERE/build_${TC}.log "FEATURE_A, .*proja(ON): ''.*"
EXPECT_ONE_OF $HERE/build_${TC}.log "FEATURE_A, .*projb(ON): ''.*"
EXPECT_ONE_OF $HERE/build_${TC}.log "Build files have been written"

# (4) Options: -DENABLE_FEATURE_A=OFF
#      proja, FEATURE_A is explicitly disabled (by global option)
#      projb, FEATURE_A is explicitly disabled (by global option)

TC=4

mkdir -p $HERE/build_${TC}
ecbuild $SOURCE/projx -DENABLE_FEATURE_A=OFF -B $HERE/build_${TC} | tee $HERE/build_${TC}.log
EXPECT_ONE_OF $HERE/build_${TC}.log "FEATURE_A, .*proja(OFF): ''.*"
EXPECT_ONE_OF $HERE/build_${TC}.log "FEATURE_A, .*projb(OFF): ''.*"
EXPECT_ONE_OF $HERE/build_${TC}.log "Build files have been written"

# (5) Options: -DENABLE_FEATURE_A=OFF -DPROJB_ENABLE_FEATURE_A=ON
#      proja, FEATURE_A is explicitly disabled (by global option)
#      projb, FEATURE_A is explicitly enabled (by project-specific option), but fails since the conditional package is not found

TC=5

mkdir -p $HERE/build_${TC}
ecbuild $SOURCE/projx -DENABLE_FEATURE_A=OFF -DPROJB_ENABLE_FEATURE_A=ON -B $HERE/build_${TC} | tee $HERE/build_${TC}.log
EXPECT_ONE_OF $HERE/build_${TC}.log " Configuring incomplete, errors occurred"

# (6) Options: -DENABLE_FEATURE_A=OFF -DPROJB_ENABLE_FEATURE_A=ON -DSOME_PACKAGE_FOUND=ON
#      proja, FEATURE_A is explicitly disabled (by global option)
#      projb, FEATURE_A is explicitly enabled (by project-specific option), possible because the conditional package is found

TC=6

mkdir -p $HERE/build_${TC}
ecbuild $SOURCE/projx -DENABLE_FEATURE_A=OFF -DPROJB_ENABLE_FEATURE_A=ON -DSOME_PACKAGE_FOUND=ON -B $HERE/build_${TC} | tee $HERE/build_${TC}.log
EXPECT_ONE_OF $HERE/build_${TC}.log "FEATURE_A, .*proja(OFF): ''.*"
EXPECT_ONE_OF $HERE/build_${TC}.log "FEATURE_A, .*projb(ON): ''.*"
EXPECT_ONE_OF $HERE/build_${TC}.log "Build files have been written"

# (7) Options: -DENABLE_FEATURE_A=ON -DPROJA_ENABLE_FEATURE_A=OFF
#      proja, FEATURE_A is explicitly disabled (by project-specific option)
#      projb, FEATURE_A is explicitly enabled (by global option), but fails since the conditional package is not found

TC=7

mkdir -p $HERE/build_${TC}
ecbuild $SOURCE/projx -DENABLE_FEATURE_A=ON -DPROJA_ENABLE_FEATURE_A=OFF -B $HERE/build_${TC} | tee $HERE/build_${TC}.log
EXPECT_ONE_OF $HERE/build_${TC}.log " Configuring incomplete, errors occurred"

# (8) Options: -DENABLE_FEATURE_A=ON -DPROJB_ENABLE_FEATURE_A=OFF -DSOME_PACKAGE_FOUND=ON
#      proja, FEATURE_A is explicitly enabled (by global option)
#      projb, FEATURE_A is explicitly disabled (by project-specific option), event if the conditional package is found

TC=8

mkdir -p $HERE/build_${TC}
ecbuild $SOURCE/projx -DENABLE_FEATURE_A=ON -DPROJB_ENABLE_FEATURE_A=OFF -DSOME_PACKAGE_FOUND=ON -B $HERE/build_${TC} | tee $HERE/build_${TC}.log
EXPECT_ONE_OF $HERE/build_${TC}.log "FEATURE_A, .*proja(ON): ''.*"
EXPECT_ONE_OF $HERE/build_${TC}.log "FEATURE_A, .*projb(OFF): ''.*"
EXPECT_ONE_OF $HERE/build_${TC}.log "Build files have been written"
