
# Configs to test:
# - CMAKE_MODULE_PATH
# - ecbuild_DIR from environment
# - ecbuild_DIR from command-line definition

set(_configs module direnv direnv-full dircmd)
foreach(_config ${_configs})
  set(_ref ${CMAKE_CURRENT_BINARY_DIR}/${_config})

  if(_config STREQUAL "module")
    unset(_EXPORTS)
    set(_CMDLINE_OPTS "-DCMAKE_MODULE_PATH=${PROJECT_SOURCE_DIR}/cmake")
  elseif(_config STREQUAL "direnv-full")
    set(_EXPORTS "export ecbuild_DIR=${PROJECT_SOURCE_DIR}")
    unset(_CMDLINE_OPTS)
  elseif(_config STREQUAL "direnv-full")
    set(_EXPORTS "export ecbuild_DIR=${PROJECT_SOURCE_DIR}/lib/cmake/ecbuild")
    unset(_CMDLINE_OPTS)
  elseif(_config STREQUAL "dircmd")
    unset(_EXPORTS)
    set(_CMDLINE_OPTS "-Decbuild_DIR=${PROJECT_SOURCE_DIR}/lib/cmake/ecbuild")
  endif()

  configure_file(run-test.sh.in ${_ref}/run-test.sh @ONLY)
  configure_file(test-CMakeLists.txt ${_ref}/CMakeLists.txt COPYONLY)

  ecbuild_add_test(
    TARGET     find-ecbuild-${_config}
    TYPE       SCRIPT
    COMMAND    ${_ref}/run-test.sh
  )
endforeach()

