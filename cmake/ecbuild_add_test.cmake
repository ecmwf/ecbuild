# (C) Copyright 1996-2015 ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

##############################################################################
#.rst:
#
# ecbuild_add_test
# ================
#
# Add a test as a script or an executable with a given list of source files. ::
#
#   ecbuild_add_test( [ TARGET <name> ]
#                     [ SOURCES <source1> [<source2> ...] ]
#                     [ OBJECTS <obj1> [<obj2> ...] ]
#                     [ COMMAND <executable> ]
#                     [ TYPE EXE|SCRIPT|PYTHON ]
#                     [ ARGS <argument1> [<argument2> ...] ]
#                     [ RESOURCES <file1> [<file2> ...] ]
#                     [ TEST_DATA <file1> [<file2> ...] ]
#                     [ BOOST ]
#                     [ MPI <number-of-ranks> ]
#                     [ ENABLED ON|OFF ]
#                     [ LIBS <library1> [<library2> ...] ]
#                     [ INCLUDES <path1> [<path2> ...] ]
#                     [ DEFINITIONS <definition1> [<definition2> ...] ]
#                     [ PERSISTENT <file1> [<file2> ...] ]
#                     [ GENERATED <file1> [<file2> ...] ]
#                     [ DEPENDS <target1> [<target2> ...] ]
#                     [ TEST_DEPENDS <target1> [<target2> ...] ]
#                     [ CONDITION <condition1> [<condition2> ...] ]
#                     [ ENVIRONMENT <variable1> [<variable2> ...] ]
#                     [ WORKING_DIRECTORY <path> ]
#                     [ CFLAGS <flag1> [<flag2> ...] ]
#                     [ CXXFLAGS <flag1> [<flag2> ...] ]
#                     [ FFLAGS <flag1> [<flag2> ...] ]
#                     [ LINKER_LANGUAGE <lang> ] )
#
# Options
# -------
#
# TARGET : either TARGET or COMMAND must be provided, unless TYPE is PYTHON
#   target name to be built
#
# SOURCES : required if TARGET is provided
#   list of source files to be compiled
#
# OBJECTS : optional
#   list of object libraries to add to this target
#
# COMMAND : either TARGET or COMMAND must be provided, unless TYPE is PYTHON
#   command or script to execute (no executable is built)
#
# TYPE : optional
#   test type, one of:
#
#   :EXE:    run built executable, default if TARGET is provided
#   :SCRIPT: run command or script, default if COMMAND is provided
#   :PYTHON: run a Python script (requires the Python interpreter to be found)
#
# ARGS : optional
#   list of arguments to pass to TARGET or COMMAND when running the test
#
# RESOURCES : optional
#   list of files to copy from the test source directory to the test directory
#
# TEST_DATA : optional
#   list of test data files to download
#
# BOOST : optional
#   use the Boost Unit Test Framework
#
# MPI : optional
#   number of MPI tasks to use.
#
#   If greater than 1, and MPI is not available, the test is disabled.
#
# ENABLED : optional
#   if set to OFF, the test is built but not enabled as a test case
#
# LIBS : optional
#   list of libraries to link against (CMake targets or external libraries)
#
# INCLUDES : optional
#   list of paths to add to include directories
#
# DEFINITIONS : optional
#   list of definitions to add to preprocessor defines
#
# PERSISTENT : optional
#   list of persistent layer object files
#
# GENERATED : optional
#   list of files to mark as generated (sets GENERATED source file property)
#
# DEPENDS : optional
#   list of targets to be built before this target
#
# TEST_DEPENDS : optional
#   list of tests to be run before this one
#
# CONDITION : optional
#   conditional expression which must evaluate to true for this target to be
#   built (must be valid in a CMake ``if`` statement)
#
# ENVIRONMENT : optional
#   list of environment variables to set in the test environment
#
# WORKING_DIRECTORY : optional
#   directory to switch to before running the test
#
# CFLAGS : optional
#   list of C compiler flags to use for all C source files
#
# CXXFLAGS : optional
#   list of C++ compiler flags to use for all C++ source files
#
# FFLAGS : optional
#   list of Fortran compiler flags to use for all Fortran source files
#
# LINKER_LANGUAGE : optional
#   sets the LINKER_LANGUAGE property on the target
#
##############################################################################

macro( ecbuild_add_test )

  set( options           BOOST )
  set( single_value_args TARGET ENABLED COMMAND TYPE LINKER_LANGUAGE MPI WORKING_DIRECTORY )
  set( multi_value_args  SOURCES OBJECTS LIBS INCLUDES TEST_DEPENDS DEPENDS ARGS
                         PERSISTENT DEFINITIONS RESOURCES TEST_DATA CFLAGS
                         CXXFLAGS FFLAGS GENERATED CONDITION ENVIRONMENT )

  cmake_parse_arguments( _PAR "${options}" "${single_value_args}" "${multi_value_args}"  ${_FIRST_ARG} ${ARGN} )

  if(_PAR_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "Unknown keywords given to ecbuild_add_test(): \"${_PAR_UNPARSED_ARGUMENTS}\"")
  endif()

  set( _TEST_DIR ${CMAKE_CURRENT_BINARY_DIR} )

  # Check for MPI
  if(_PAR_MPI)
    if( (_PAR_MPI GREATER 1) AND ( (NOT HAVE_MPI) OR (NOT MPIEXEC) ) )
      ecbuild_debug("ecbuild_add_test(${_PAR_TARGET}): ${_PAR_MPI} MPI ranks requested but MPI not available - disabling test")
      set( _PAR_ENABLED 0 )
    endif()
    if( (_PAR_MPI EQUAL 1) AND (NOT HAVE_MPI) )
      ecbuild_debug("ecbuild_add_test(${_PAR_TARGET}): 1 MPI rank requested but MPI not available - disabling MPI")
      set( _PAR_MPI 0 )
    endif()
  endif()

  # default is enabled
  if( NOT DEFINED _PAR_ENABLED )
    set( _PAR_ENABLED 1 )
  endif()


  ### check test type

  # command implies script
  if( DEFINED _PAR_COMMAND )
    set( _PAR_TYPE "SCRIPT" )
  endif()

  # default of TYPE
  if( NOT _PAR_TYPE AND DEFINED _PAR_TARGET )
    set( _PAR_TYPE "EXE" )
    if( NOT _PAR_SOURCES )
      message(FATAL_ERROR "The call to ecbuild_add_test() defines a TARGET without SOURCES.")
    endif()
  endif()

  if( _PAR_TYPE MATCHES "PYTHON" )
    if( PYTHONINTERP_FOUND )
      set( _PAR_COMMAND ${PYTHON_EXECUTABLE} )
    else()
      message( WARNING "Requested a python test but python interpreter not found - disabling test\nPYTHON_EXECUTABLE: [${PYTHON_EXECUTABLE}]" )
      set( _PAR_ENABLED 0 )
    endif()
  endif()

  ### further checks

  if( _PAR_ENABLED AND NOT _PAR_TARGET AND NOT _PAR_COMMAND )
    message(FATAL_ERROR "The call to ecbuild_add_test() defines neither a TARGET nor a COMMAND.")
  endif()

  if( _PAR_ENABLED AND NOT _PAR_COMMAND AND NOT _PAR_SOURCES )
    message(FATAL_ERROR "The call to ecbuild_add_test() defines neither a COMMAND nor SOURCES, so no test can be defined or built.")
  endif()

  if( _PAR_TYPE MATCHES "SCRIPT" AND NOT _PAR_COMMAND )
    message(FATAL_ERROR "The call to ecbuild_add_test() defines a 'script' but doesn't specify the COMMAND.")
  endif()

  ### conditional build

  if( DEFINED _PAR_CONDITION )
    set(_target_condition_file "${_TEST_DIR}/set_${_PAR_TARGET}_condition.cmake")
    file( WRITE  ${_target_condition_file} "  if( ")
    foreach( term ${_PAR_CONDITION} )
      file( APPEND ${_target_condition_file} " ${term}")
    endforeach()
    file( APPEND ${_target_condition_file} " )\n    set(_${_PAR_TARGET}_condition TRUE)\n  else()\n    set(_${_PAR_TARGET}_condition FALSE)\n  endif()\n")
    include( ${_target_condition_file} )
  else()
    set( _${_PAR_TARGET}_condition TRUE )
  endif()

  # boost unit test linking to unit_test lib ?

  if( _PAR_BOOST AND ENABLE_TESTS AND _${_PAR_TARGET}_condition )

    if( HAVE_BOOST_UNIT_TEST )
      if( BOOST_UNIT_TEST_FRAMEWORK_HEADER_ONLY )
        include_directories( ${ECBUILD_BOOST_HEADER_DIRS} )
        include_directories( ${Boost_INCLUDE_DIRS}  ) # temporary until we ship Boost Unit Test with ecBuild
      else()
        include_directories( ${ECBUILD_BOOST_HEADER_DIRS} ${Boost_INCLUDE_DIRS} )
      endif()
    else()
      ecbuild_debug("ecbuild_add_test(${_PAR_TARGET}): boost unit test framework not available - not building test")
      set( _${_PAR_TARGET}_condition FALSE )
    endif()

  endif()

  ### enable the tests

  if( ENABLE_TESTS AND _${_PAR_TARGET}_condition )

    # add resources

    if( DEFINED _PAR_RESOURCES )
      ecbuild_debug("ecbuild_add_test(${_PAR_TARGET}): copying resources ${_PAR_RESOURCES}")
      foreach( rfile ${_PAR_RESOURCES} )
        execute_process( COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_CURRENT_SOURCE_DIR}/${rfile} ${_TEST_DIR} )
      endforeach()
    endif()

    # build executable

    if( DEFINED _PAR_SOURCES )

      # add include dirs if defined
      if( DEFINED _PAR_INCLUDES )
        list(REMOVE_DUPLICATES _PAR_INCLUDES )
        foreach( path ${_PAR_INCLUDES} ) # skip NOTFOUND
          if( path )
            ecbuild_debug("ecbuild_add_test(${_PAR_TARGET}): add ${path} to include_directories")
            include_directories( ${path} )
          else()
            ecbuild_debug("ecbuild_add_test(${_PAR_TARGET}): ${path} not found - not adding to include_directories")
          endif()
        endforeach()
      endif()

      # add persistent layer files
      if( DEFINED _PAR_PERSISTENT )
        if( DEFINED PERSISTENT_NAMESPACE )
          ecbuild_add_persistent( SRC_LIST _PAR_SOURCES FILES ${_PAR_PERSISTENT} NAMESPACE ${PERSISTENT_NAMESPACE} )
        else()
          ecbuild_add_persistent( SRC_LIST _PAR_SOURCES FILES ${_PAR_PERSISTENT} )
        endif()
      endif()

      # insert already compiled objects (from OBJECT libraries)
      unset( _all_objects )
      foreach( _obj ${_PAR_OBJECTS} )
        list( APPEND _all_objects $<TARGET_OBJECTS:${_obj}> )
      endforeach()

      add_executable( ${_PAR_TARGET} ${_PAR_SOURCES} ${_all_objects} )

      # add extra dependencies
      if( DEFINED _PAR_DEPENDS)
        ecbuild_debug("ecbuild_add_test(${_PAR_TARGET}): add dependency on ${_PAR_DEPENDS}")
        add_dependencies( ${_PAR_TARGET} ${_PAR_DEPENDS} )
      endif()

      # add the link libraries
      if( DEFINED _PAR_LIBS )
        list(REMOVE_DUPLICATES _PAR_LIBS )
        list(REMOVE_ITEM _PAR_LIBS debug)
        list(REMOVE_ITEM _PAR_LIBS optimized)
        foreach( lib ${_PAR_LIBS} ) # skip NOTFOUND
          if( lib )
            ecbuild_debug("ecbuild_add_test(${_PAR_TARGET}): linking with ${lib}")
            target_link_libraries( ${_PAR_TARGET} ${lib} )
          else()
            ecbuild_debug("ecbuild_add_test(${_PAR_TARGET}): ${lib} not found - not linking")
          endif()
        endforeach()
      endif()

      # add test libraries
      if( _PAR_BOOST AND BOOST_UNIT_TEST_FRAMEWORK_LINKED AND HAVE_BOOST_UNIT_TEST )
        target_link_libraries( ${_PAR_TARGET} ${Boost_UNIT_TEST_FRAMEWORK_LIBRARY} ${Boost_TEST_EXEC_MONITOR_LIBRARY} )
      endif()

      # filter sources
      ecbuild_separate_sources( TARGET ${_PAR_TARGET} SOURCES ${_PAR_SOURCES} )

      # add local flags
      if( DEFINED _PAR_CFLAGS )
        ecbuild_debug("ecbuild_add_test(${_PAR_TARGET}): use C flags ${_PAR_CFLAGS}")
        set_source_files_properties( ${${_PAR_TARGET}_c_srcs}   PROPERTIES COMPILE_FLAGS "${_PAR_CFLAGS}" )
      endif()
      if( DEFINED _PAR_CXXFLAGS )
        ecbuild_debug("ecbuild_add_test(${_PAR_TARGET}): use C++ flags ${_PAR_CFLAGS}")
        set_source_files_properties( ${${_PAR_TARGET}_cxx_srcs} PROPERTIES COMPILE_FLAGS "${_PAR_CXXFLAGS}" )
      endif()
      if( DEFINED _PAR_FFLAGS )
        ecbuild_debug("ecbuild_add_test(${_PAR_TARGET}): use Fortran flags ${_PAR_CFLAGS}")
        set_source_files_properties( ${${_PAR_TARGET}_f_srcs}   PROPERTIES COMPILE_FLAGS "${_PAR_FFLAGS}" )
      endif()
      if( DEFINED _PAR_GENERATED )
        ecbuild_debug("ecbuild_add_test(${_PAR_TARGET}): mark as generated ${_PAR_GENERATED}")
        set_source_files_properties( ${_PAR_GENERATED} PROPERTIES GENERATED 1 )
      endif()


      # modify definitions to compilation ( -D... )
      get_property( _target_defs TARGET ${_PAR_TARGET} PROPERTY COMPILE_DEFINITIONS )

      if( DEFINED _PAR_DEFINITIONS )
        list( APPEND _target_defs ${_PAR_DEFINITIONS} )
      endif()

      if( _PAR_BOOST AND BOOST_UNIT_TEST_FRAMEWORK_HEADER_ONLY )
        list( APPEND _target_defs BOOST_UNIT_TEST_FRAMEWORK_HEADER_ONLY )
      endif()

      if( _target_defs )
        ecbuild_debug("ecbuild_add_test(${_PAR_TARGET}): using definitions ${_target_defs}")
        set_property( TARGET ${_PAR_TARGET} PROPERTY COMPILE_DEFINITIONS ${_target_defs} )
      endif()

      # set build location to local build dir
      # not the project base as defined for libs and execs
      set_property( TARGET ${_PAR_TARGET} PROPERTY RUNTIME_OUTPUT_DIRECTORY ${_TEST_DIR} )

      # whatever project settings are, we always build tests with the build_rpath, not the install_rpath
      set_property( TARGET ${_PAR_TARGET} PROPERTY BUILD_WITH_INSTALL_RPATH FALSE )
      set_property( TARGET ${_PAR_TARGET} PROPERTY SKIP_BUILD_RPATH         FALSE )

      # set linker language
      if( DEFINED _PAR_LINKER_LANGUAGE )
        ecbuild_debug("ecbuild_add_test(${_PAR_TARGET}): using linker language ${_PAR_LINKER_LANGUAGE}")
        set_property( TARGET ${_PAR_TARGET} PROPERTY LINKER_LANGUAGE ${_PAR_LINKER_LANGUAGE} )
      endif()

      # make sure target is removed before - some problems with AIX
      get_target_property(EXE_FILENAME ${_PAR_TARGET} OUTPUT_NAME)
      add_custom_command( TARGET ${_PAR_TARGET}
                          PRE_BUILD
                          COMMAND ${CMAKE_COMMAND} -E remove ${EXE_FILENAME} )

    endif() # _PAR_SOURCES

    if( DEFINED _PAR_COMMAND AND NOT _PAR_TARGET ) # in the absence of target, we use the command as a name
      set( _PAR_TARGET ${_PAR_COMMAND} )
    endif()

    # scripts dont have actual build targets
    # we build a phony target to trigger the dependencies
    if( DEFINED _PAR_COMMAND AND DEFINED _PAR_DEPENDS )

      add_custom_target( ${_PAR_TARGET}.x ALL COMMAND ${CMAKE_COMMAND} -E touch ${_PAR_TARGET}.x )

      add_dependencies( ${_PAR_TARGET}.x ${_PAR_DEPENDS} )

    endif()


    # define the arguments
    set( TEST_ARGS "" )
    if( DEFINED _PAR_ARGS  )
      list( APPEND TEST_ARGS ${_PAR_ARGS} )
    endif()

    # Wrap with MPIEXEC
    if( _PAR_MPI )
      if( DEFINED _PAR_COMMAND )
        ecbuild_debug("ecbuild_add_test(${_PAR_TARGET}): running as ${MPIEXEC} -n ${_PAR_MPI} ${_TEST_DIR}/${_PAR_COMMAND}")
        set( _PAR_COMMAND ${MPIEXEC} -n ${_PAR_MPI} ${_TEST_DIR}/${_PAR_COMMAND} )
      else()
        ecbuild_debug("ecbuild_add_test(${_PAR_TARGET}): running as ${MPIEXEC} -n ${_PAR_MPI} ${_TEST_DIR}/${_PAR_TARGET}")
        set( _PAR_COMMAND ${MPIEXEC} -n ${_PAR_MPI} ${_TEST_DIR}/${_PAR_TARGET} )
      endif()
    endif()

    ### define the test

    if( _PAR_ENABLED ) # we can disable and still build it but not run it with 'make tests'

      if( DEFINED _PAR_COMMAND )
        add_test( ${_PAR_TARGET} ${_PAR_COMMAND} ${TEST_ARGS} ${_working_dir} ) # run a command as test
      else()
        add_test( ${_PAR_TARGET} ${_PAR_TARGET}  ${TEST_ARGS} ${_working_dir} ) # run the test that was generated
      endif()

      # get test data

      if( _PAR_TEST_DATA )

        ecbuild_get_test_multidata( TARGET ${_PAR_TARGET}_data NAMES ${_PAR_TEST_DATA} )

        list( APPEND _PAR_TEST_DEPENDS ${_PAR_TARGET}_data )

      endif()

      if( DEFINED _PAR_ENVIRONMENT )
        set_property( TEST ${_PAR_TARGET} APPEND PROPERTY ENVIRONMENT "${_PAR_ENVIRONMENT}" )
      endif()

      if( DEFINED _PAR_WORKING_DIRECTORY )
        ecbuild_debug("ecbuild_add_test(${_PAR_TARGET}): set working directory to ${_PAR_WORKING_DIRECTORY}")
        set_tests_properties( ${_PAR_TARGET} PROPERTIES WORKING_DIRECTORY "${_PAR_WORKING_DIRECTORY}")
      endif()

      if( DEFINED _PAR_TEST_DEPENDS )
        ecbuild_debug("ecbuild_add_test(${_PAR_TARGET}): set test dependencies to ${_PAR_TEST_DEPENDS}")
        set_property( TEST ${_PAR_TARGET} APPEND PROPERTY DEPENDS "${_PAR_TEST_DEPENDS}" )
      endif()

    endif()

    # add to the overall list of tests
    list( APPEND ECBUILD_ALL_TESTS ${_PAR_TARGET} )
    list( REMOVE_DUPLICATES ECBUILD_ALL_TESTS )
    set( ECBUILD_ALL_TESTS ${ECBUILD_ALL_TESTS} CACHE INTERNAL "" )

  endif() # _condition

  # finally mark project files
  ecbuild_declare_project_files( ${_PAR_SOURCES} )

endmacro( ecbuild_add_test )
