# Config-bundle with separate configuration for subproj2

    SRC_DIR=$(pwd)
    BUILD_DIR=$(pwd)/build
    mkdir -p ${BUILD_DIR} && cd ${BUILD_DIR}

    ../../../bin/ecbuild --build=debug --log=debug --config=${SRC_DIR}/general_config.cmake -- -DSUBPROJ2_CONFIG=${SRC_DIR}/subproj2_config.cmake ${SRC_DIR}
