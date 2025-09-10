# (C) Copyright 2011- ECMWF.
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
#                     [ LABELS <label1> [<label2> ...] ]
#                     [ ARGS <argument1> [<argument2> ...] ]
#                     [ RESOURCES <file1> [<file2> ...] ]
#                     [ TEST_DATA <file1> [<file2> ...] ]
#                     [ MPI <number-of-mpi-tasks> ]
#                     [ OMP <number-of-threads-per-mpi-task> ]
#                     [ ENABLED ON|OFF ]
#                     [ LIBS <library1> [<library2> ...] ]
#                     [ NO_AS_NEEDED ]
#                     [ INCLUDES <path1> [<path2> ...] ]
#                     [ DEFINITIONS <definition1> [<definition2> ...] ]
#                     [ PERSISTENT <file1> [<file2> ...] ]
#                     [ GENERATED <file1> [<file2> ...] ]
#                     [ DEPENDS <target1> [<target2> ...] ]
#                     [ TEST_DEPENDS <target1> [<target2> ...] ]
#                     [ TEST_REQUIRES <target1> [<target2> ...] ]
#                     [ CONDITION <condition> ]
#                     [ PROPERTIES <prop1> <val1> [<prop2> <val2> ...] ]
#                     [ TEST_PROPERTIES <prop1> <val1> [<prop2> <val2> ...] ]
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
# LABELS : optional
#   list of labels to assign to the test
#
#   The project name in lower case is always added as a label. Additional
#   labels are assigned depending on the type of test:
#
#   :executable: for type ``EXE``
#   :script:     for type ``SCRIPT``
#   :python:     for type ``PYTHON``
#   :mpi:        if ``MPI`` is set
#   :openmp:     if ``OMP`` is set
#
#   This allows selecting tests to run via ``ctest -L <regex>`` or tests
#   to exclude via ``ctest -LE <regex>``.
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
# MPI : optional
#   Run with MPI using the given number of MPI tasks.
#
#   If greater than 1, and ``MPIEXEC`` is not available, the test is disabled.
#
# OMP : optional
#   number of OpenMP threads per MPI task to use.
#
#   If set, the environment variable OMP_NUM_THREADS will set.
#   Also, in case of launchers like aprun, the OMP_NUMTHREADS_FLAG will be used.
#
# ENABLED : optional
#   if set to OFF, the test is built but not enabled as a test case
#
# LIBS : optional
#   list of libraries to link against (CMake targets or external libraries)
#
# NO_AS_NEEDED: optional
#   add --no-as-needed linker flag, to prevent stripping libraries that looks like are not used
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
# TEST_REQUIRES : optional
#   list of tests that will automatically run before this one
#
# CONDITION : optional
#   conditional expression which must evaluate to true for this target to be
#   built (must be valid in a CMake ``if`` statement)
#
# PROPERTIES : optional
#   custom properties to set on the target
#
# TEST_PROPERTIES : optional
#   custom properties to set on the test
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
#   See usage note below.
#
# CXXFLAGS : optional
#   list of C++ compiler flags to use for all C++ source files
#
#   See usage note below.
#
# FFLAGS : optional
#   list of Fortran compiler flags to use for all Fortran source files
#
#   See usage note below.
#
# LINKER_LANGUAGE : optional
#   sets the LINKER_LANGUAGE property on the target
#
# Usage
# -----
#
# The ``CFLAGS``, ``CXXFLAGS`` and ``FFLAGS`` options apply the given compiler
# flags to all C, C++ and Fortran sources passed to this command, respectively.
# If any two ``ecbuild_add_executable``, ``ecbuild_add_library`` or
# ``ecbuild_add_test`` commands are passed the *same* source file and each sets
# a different value for the compiler flags to be applied to that file (including
# when one command adds flags and another adds none), then the two commands
# will be in conflict and the result may not be as expected.
#
# For this reason it is recommended not to use the ``*FLAGS`` options when
# multiple targets share the same source files, unless the exact same flags are
# applied to those sources by each relevant command.
#
# Care should also be taken to ensure that these commands are not passed source
# files which are not required to build the target, if those sources are also
# passed to other commands which set different compiler flags.
#
##############################################################################

function( ecbuild_add_test )

  set( options           NO_AS_NEEDED )
  set( single_value_args TARGET ENABLED COMMAND TYPE LINKER_LANGUAGE MPI OMP WORKING_DIRECTORY )
  set( multi_value_args  SOURCES OBJECTS LIBS INCLUDES TEST_DEPENDS DEPENDS TEST_REQUIRES LABELS ARGS
                         PERSISTENT DEFINITIONS RESOURCES TEST_DATA CFLAGS
                         CXXFLAGS FFLAGS GENERATED CONDITION TEST_PROPERTIES PROPERTIES ENVIRONMENT )

  cmake_parse_arguments( _PAR "${options}" "${single_value_args}" "${multi_value_args}"  ${_FIRST_ARG} ${ARGN} )

  if(_PAR_UNPARSED_ARGUMENTS)
    ecbuild_critical("Unknown keywords given to ecbuild_add_test(): \"${_PAR_UNPARSED_ARGUMENTS}\"")
  endif()

  set( _TEST_DIR ${CMAKE_CURRENT_BINARY_DIR} )

  # Undocumented flag for disabling all MPI tests for test environment without suitable MPI(EXEC)
  if( _PAR_MPI AND ECBUILD_DISABLE_MPI_TESTS )
    ecbuild_debug("ecbuild_add_test(${_PAR_TARGET}): ECBUILD_DISABLE_MPI_TESTS set - disabling test")
    set( _PAR_ENABLED 0 )
  elseif( _PAR_MPI )
    # Check for MPIEXEC if it not set
    if( MPIEXEC_EXECUTABLE )
      set( MPIEXEC ${MPIEXEC_EXECUTABLE} )
    endif()
    if( NOT MPIEXEC )
      find_program( MPIEXEC NAMES mpiexec mpirun lamexec srun
                    DOC "Executable for running MPI programs." )
    endif()

    if( MPIEXEC )
      set(MPIEXEC_NUMPROC_FLAG "-np" CACHE STRING "Flag used by MPI to specify the number of processes for MPIEXEC")
      ecbuild_debug("ecbuild_add_test(${_PAR_TARGET}): Running using ${MPIEXEC} on ${_PAR_MPI} MPI rank(s)")
      set( _PAR_LABELS mpi ${_PAR_LABELS} )
    elseif( _PAR_MPI GREATER 1 )
      ecbuild_debug("ecbuild_add_test(${_PAR_TARGET}): ${_PAR_MPI} MPI ranks requested but MPIEXEC not available - disabling test")
      set( _PAR_ENABLED 0 )
    else()
      ecbuild_debug("ecbuild_add_test(${_PAR_TARGET}): 1 MPI rank requested but MPIEXEC not available - running sequentially")
      set( _PAR_MPI 0 )
    endif()
  endif()

  # Check for OMP
  if( DEFINED _PAR_OMP )
    set( _PAR_LABELS openmp ${_PAR_LABELS} )
  else()
    set( _PAR_OMP 1 )
  endif()
  list( APPEND _PAR_ENVIRONMENT "OMP_NUM_THREADS=${_PAR_OMP}" )


  # default is enabled
  if( NOT DEFINED _PAR_ENABLED )
    set( _PAR_ENABLED 1 )
  endif()


  ### check test type

  # command implies script
  if( DEFINED _PAR_COMMAND )
    set( _PAR_TYPE "SCRIPT" )
    set( _PAR_LABELS script ${_PAR_LABELS} )
  endif()

  # default of TYPE
  if( NOT _PAR_TYPE AND DEFINED _PAR_TARGET )
    set( _PAR_TYPE "EXE" )
    set( _PAR_LABELS executable ${_PAR_LABELS} )
    if( NOT _PAR_SOURCES )
      ecbuild_critical("The call to ecbuild_add_test() defines a TARGET without SOURCES.")
    endif()
  endif()

  ### conditional build

  ecbuild_evaluate_dynamic_condition( _PAR_CONDITION _${_PAR_TARGET}_condition )

  ### enable the tests

  if( HAVE_TESTS AND _${_PAR_TARGET}_condition AND _PAR_ENABLED )

    if( _PAR_TYPE MATCHES "PYTHON" )
      if( PYTHONINTERP_FOUND )
        set( _PAR_COMMAND ${PYTHON_EXECUTABLE} )
        set( _PAR_LABELS python ${_PAR_LABELS} )
      else()
        ecbuild_warn( "Requested a python test but python interpreter not found - disabling test\nPYTHON_EXECUTABLE: [${PYTHON_EXECUTABLE}]" )
        set( _PAR_ENABLED 0 )
      endif()
    endif()

    ### further checks

    if( _PAR_ENABLED AND NOT _PAR_TARGET AND NOT _PAR_COMMAND )
      ecbuild_critical("The call to ecbuild_add_test() defines neither a TARGET nor a COMMAND.")
    endif()

    if( _PAR_ENABLED AND NOT _PAR_COMMAND AND NOT _PAR_SOURCES )
      ecbuild_critical("The call to ecbuild_add_test() defines neither a COMMAND nor SOURCES, so no test can be defined or built.")
    endif()

    if( _PAR_TYPE MATCHES "SCRIPT" AND NOT _PAR_COMMAND )
      ecbuild_critical("The call to ecbuild_add_test() defines a 'script' but doesn't specify the COMMAND.")
    endif()

    # add resources

    if( DEFINED _PAR_RESOURCES )
      ecbuild_debug("ecbuild_add_test(${_PAR_TARGET}): copying resources ${_PAR_RESOURCES}")
      foreach( rfile ${_PAR_RESOURCES} )
        execute_process( COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_CURRENT_SOURCE_DIR}/${rfile} ${_TEST_DIR} )
      endforeach()
    endif()

    # build executable

    if( DEFINED _PAR_SOURCES )

      # add persistent layer files
      ecbuild_add_persistent( SRC_LIST _PAR_SOURCES FILES ${_PAR_PERSISTENT} NAMESPACE "${PERSISTENT_NAMESPACE}" )

      # insert already compiled objects (from OBJECT libraries)
      unset( _all_objects )
      foreach( _obj ${_PAR_OBJECTS} )
        list( APPEND _all_objects $<TARGET_OBJECTS:${_obj}> )
      endforeach()

      ecbuild_separate_sources( TARGET ${_PAR_TARGET} SOURCES ${_PAR_SOURCES} )

      if( ${_PAR_TARGET}_cuda_srcs AND CUDA_FOUND )
        cuda_add_executable( ${_PAR_TARGET} ${_PAR_SOURCES}  ${_all_objects} )
      else()
        add_executable( ${_PAR_TARGET} ${_PAR_SOURCES} ${_all_objects} )
      endif()

      # add include dirs if defined
      if( DEFINED _PAR_INCLUDES )
        ecbuild_filter_list(INCLUDES LIST ${_PAR_INCLUDES} LIST_INCLUDE path LIST_EXCLUDE skipped_path)
        ecbuild_debug("ecbuild_add_test(${_PAR_TARGET}): add [${path}] to include_directories")
        if( ECBUILD_2_COMPAT )
          include_directories( ${path} )
        else()
          target_include_directories(${_PAR_TARGET} PRIVATE ${path} )
        endif()
        ecbuild_debug("ecbuild_add_test(${_PAR_TARGET}): [${skipped_path}] not found - not adding to include_directories")
      endif()

      # add extra dependencies
      if( DEFINED _PAR_DEPENDS)
        ecbuild_debug("ecbuild_add_test(${_PAR_TARGET}): add dependency on ${_PAR_DEPENDS}")
        add_dependencies( ${_PAR_TARGET} ${_PAR_DEPENDS} )
      endif()

      # add the link libraries
      if( DEFINED _PAR_LIBS )
        list(REMOVE_ITEM _PAR_LIBS debug)
        list(REMOVE_ITEM _PAR_LIBS optimized)
        ecbuild_filter_list(LIBS LIST ${_PAR_LIBS} LIST_INCLUDE lib LIST_EXCLUDE skipped_lib)
        ecbuild_debug("ecbuild_add_test(${_PAR_TARGET}): linking with [${lib}]")
        if ( _PAR_NO_AS_NEEDED AND CMAKE_SYSTEM_NAME MATCHES "Linux" AND CMAKE_CXX_COMPILER_ID MATCHES "GNU" )
          target_link_libraries( ${_PAR_TARGET} -Wl,--no-as-needed ${lib} )
        else()
          target_link_libraries( ${_PAR_TARGET} ${lib} )
        endif()
        ecbuild_debug("ecbuild_add_test(${_PAR_TARGET}): [${skipped_lib}] not found - not linking")
      endif()

      # Override compilation flags on a per source file basis
      ecbuild_target_flags( ${_PAR_TARGET} "${_PAR_CFLAGS}" "${_PAR_CXXFLAGS}" "${_PAR_FFLAGS}" )

      if( DEFINED _PAR_GENERATED )
        ecbuild_debug("ecbuild_add_test(${_PAR_TARGET}): mark as generated ${_PAR_GENERATED}")
        set_source_files_properties( ${_PAR_GENERATED} PROPERTIES GENERATED 1 )
      endif()

      if( DEFINED _PAR_DEFINITIONS )
        target_compile_definitions(${_PAR_TARGET} PRIVATE ${_PAR_DEFINITIONS})
        ecbuild_debug("ecbuild_add_test(${_PAR_TARGET}): adding definitions ${_PAR_DEFINITIONS}")
      endif()

      # set linker language
      if( DEFINED _PAR_LINKER_LANGUAGE )
        ecbuild_debug("ecbuild_add_test(${_PAR_TARGET}): using linker language ${_PAR_LINKER_LANGUAGE}")
        set_target_properties( ${_PAR_TARGET} PROPERTIES LINKER_LANGUAGE ${_PAR_LINKER_LANGUAGE} )
        if( ECBUILD_${_PAR_LINKER_LANGUAGE}_IMPLICIT_LINK_LIBRARIES )
          target_link_libraries( ${_PAR_TARGET} ${ECBUILD_${_PAR_LINKER_LANGUAGE}_IMPLICIT_LINK_LIBRARIES} )
        endif()
      endif()

      if( ECBUILD_IMPLICIT_LINK_LIBRARIES )
        target_link_libraries( ${_PAR_TARGET} ${ECBUILD_IMPLICIT_LINK_LIBRARIES} )
      endif()


      # set build location to local build dir
      # not the project base as defined for libs and execs
      set_target_properties( ${_PAR_TARGET} PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${_TEST_DIR} )

      # whatever project settings are, we always build tests with the build_rpath, not the install_rpath
      set_target_properties( ${_PAR_TARGET} PROPERTIES BUILD_WITH_INSTALL_RPATH FALSE )
      set_target_properties( ${_PAR_TARGET} PROPERTIES SKIP_BUILD_RPATH         FALSE )

      # set linker language
      if( DEFINED _PAR_LINKER_LANGUAGE )
        ecbuild_debug("ecbuild_add_test(${_PAR_TARGET}): using linker language ${_PAR_LINKER_LANGUAGE}")
        set_target_properties( ${_PAR_TARGET} PROPERTIES LINKER_LANGUAGE ${_PAR_LINKER_LANGUAGE} )
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
    list( APPEND TEST_ARGS ${_PAR_ARGS} )

    # Wrap with MPIEXEC
    if( _PAR_MPI )

      set( MPIEXEC_TASKS ${MPIEXEC_NUMPROC_FLAG} ${_PAR_MPI} )
      if( DEFINED MPIEXEC_NUMTHREAD_FLAG )
        set( MPIEXEC_THREADS ${MPIEXEC_NUMTHREAD_FLAG} ${_PAR_OMP} )
      endif()

      # MPI_ARGS is left for users to define @ configure time e.g. -DMPI_ARGS="--oversubscribe"
      if( MPI_ARGS )
        string(REGEX REPLACE "^\"(.*)\"$" "\\1" MPI_ARGS_REMOVED_OUTER_QUOTES ${MPI_ARGS} )
        string(REPLACE " " ";" MPI_ARGS_LIST ${MPI_ARGS_REMOVED_OUTER_QUOTES})
      endif()
      set( _LAUNCH ${MPIEXEC} ${MPI_ARGS_LIST} ${MPIEXEC_TASKS} ${MPIEXEC_THREADS} )

      if( NOT _PAR_COMMAND AND _PAR_TARGET )
          set( _PAR_COMMAND ${_PAR_TARGET} )
      endif()
      ecbuild_debug("ecbuild_add_test(${_PAR_TARGET}): running as ${_LAUNCH} ${_PAR_COMMAND}")
      if( TARGET ${_PAR_COMMAND} )
          set( _PAR_COMMAND ${_LAUNCH} $<TARGET_FILE:${_PAR_COMMAND}> )
      else()
          set( _PAR_COMMAND ${_LAUNCH} ${_PAR_COMMAND} )
      endif()
    endif()

    ### define the test

    if( _PAR_ENABLED ) # we can disable and still build it but not run it with 'make tests'

      if( EC_OS_NAME MATCHES "windows" AND ${_PAR_TYPE} MATCHES "SCRIPT" )
        # Windows has to be explicitly told to use bash for the tests.
        if( NOT DEFINED WINDOWS_TESTING_BASHRC )
            set( WINDOWS_TESTING_BASHRC "${CMAKE_CURRENT_SOURCE_DIR}/windows_testing.bashrc" )
        endif()
        set( _WIN_CMD ${BASH_EXE} "--rcfile" "${WINDOWS_TESTING_BASHRC}" "-ci" )
      else()
        set( _WIN_CMD "" )
      endif()

      if( DEFINED _PAR_COMMAND )
        add_test( NAME ${_PAR_TARGET} COMMAND ${_WIN_CMD} ${_PAR_COMMAND} ${TEST_ARGS} ${_working_dir} ) # run a command as test
      else()
        add_test( NAME ${_PAR_TARGET} COMMAND ${_WIN_CMD} ${_PAR_TARGET}  ${TEST_ARGS} ${_working_dir} ) # run the test that was generated
      endif()

      # Set custom properties
      if( DEFINED _PAR_PROPERTIES )
        set_target_properties( ${_PAR_TARGET} PROPERTIES ${_PAR_PROPERTIES} )
      endif()

      if( DEFINED _PAR_TEST_PROPERTIES )
        set_tests_properties( ${_PAR_TARGET} PROPERTIES ${_PAR_TEST_PROPERTIES} )
      endif()

      # Set the fictures properties if test requires another test to run before
      if ( DEFINED _PAR_TEST_REQUIRES )
        ecbuild_debug("ecbuild_add_test(${_PAR_TARGET}): set test requirements to ${_PAR_TEST_REQUIRES}")
        foreach(_requirement ${_PAR_TEST_REQUIRES} )
          set_tests_properties( ${_requirement} PROPERTIES FIXTURES_SETUP ${_requirement} )
        endforeach()
        set_tests_properties( ${_PAR_TARGET} PROPERTIES FIXTURES_REQUIRED "${_PAR_TEST_REQUIRES}" )
      endif()

      # get test data

      if( _PAR_TEST_DATA )

        ecbuild_get_test_multidata( TARGET ${_PAR_TARGET}_data NAMES ${_PAR_TEST_DATA} )

        list( APPEND _PAR_TEST_DEPENDS ${_PAR_TARGET}_data )

      endif()

      # Add lower case project name to custom test labels
      string( TOLOWER ${PROJECT_NAME} PROJECT_NAME_LOWCASE )
      set( _PAR_LABELS ${PROJECT_NAME_LOWCASE} ${_PAR_LABELS} )
      list( REMOVE_DUPLICATES _PAR_LABELS )
      ecbuild_debug("ecbuild_add_test(${_PAR_TARGET}): assign labels ${_PAR_LABELS}")
      set_property( TEST ${_PAR_TARGET} APPEND PROPERTY LABELS "${_PAR_LABELS}" )

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

endfunction( ecbuild_add_test )
