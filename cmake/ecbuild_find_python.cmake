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
# ecbuild_find_python
# ===================
#
# Find Python interpreter, its version and the Python libraries. ::
#
#   ecbuild_find_python( [ VERSION <version> ] [ REQUIRED ] [ NO_LIBS ] )
#
# Options
# -------
#
# VERSION : optional
#   minimum required version
#
# REQUIRED : optional
#   fail if Python was not found
#
# NO_LIBS : optional
#   only search for the Python interpreter, not the libraries
#
# Unless ``NO_LIBS`` is set, the ``python-config`` utility, if found, is used
# to determine the Python include directories, libraries and link line. Set the
# CMake variable ``PYTHON_NO_CONFIG`` to use CMake's FindPythonLibs instead.
#
# Output variables
# ----------------
#
# The following CMake variables are set if python was found:
#
# :Python_Interpreter_FOUND: Python interpreter was found
# :Python_Development_FOUND: Python (development) libraries were found
# :Python_FOUND:             Python was found (both interpreter and libraries)
# :Python_EXECUTABLE:        Python executable
# :Python_VERSION_MAJOR:     Major version number
# :Python_VERSION_MINOR:     Minor version number
# :Python_VERSION_PATCH:     Patch version number
# :Python_VERSION:           Python version
# :Python_INCLUDE_DIRS:      Python include directories
# :Python_LIBRARIES:         Python libraries
# :Python_SITELIB:           Python site packages directory
#
# The following variables with prefix ``PYTHON_`` are now *DEPRECATED* and
# will be removed in a future version; these variables are still set for
# backwards compatibility. The new variables with prefix ``Python_``
# should be used instead. 
# 
# :PYTHONINTERP_FOUND:    Python interpreter was found
# :PYTHONLIBS_FOUND:      Python libraries were found
# :PYTHON_FOUND:          Python was found (both interpreter and libraries)
# :PYTHON_EXECUTABLE:     Python executable
# :PYTHON_VERSION_MAJOR:  major version number
# :PYTHON_VERSION_MINOR:  minor version number
# :PYTHON_VERSION_PATCH:  patch version number
# :PYTHON_VERSION_STRING: Python version
# :PYTHON_INCLUDE_DIRS:   Python include directories
# :PYTHON_LIBRARIES:      Python libraries
# :PYTHON_SITE_PACKAGES:  Python site packages directory
# 
##############################################################################

set( __test_python ${CMAKE_CURRENT_LIST_DIR}/pymain.c )

function( ecbuild_find_python )

    # parse parameters

    set( options REQUIRED NO_LIBS )
    set( single_value_args VERSION )
    set( multi_value_args  )

    cmake_parse_arguments( _p "${options}" "${single_value_args}" "${multi_value_args}"  ${_FIRST_ARG} ${ARGN} )

    if(_p_UNPARSED_ARGUMENTS)
      ecbuild_critical("Unknown keywords given to ecbuild_find_python(): \"${_p_UNPARSED_ARGUMENTS}\"")
    endif()
    if( _p_REQUIRED )
      ecbuild_debug( "ecbuild_find_python: Searching for Python interpreter (required) ..." )
      set( _p_REQUIRED REQUIRED )
    else()
      ecbuild_debug( "ecbuild_find_python: Searching for Python interpreter ..." )
      unset( _p_REQUIRED )
    endif()

    # find python interpreter/executable

    # Search first without specifying the version, since doing so gives preference to the specified
    # version even though a never version of the interpreter may be available
    if ( _p_NO_LIBS )
      find_package( Python ${_p_VERSION} COMPONENTS Interpreter ${_p_REQUIRED} )
      set( __required_vars Python_FOUND Python_Interpreter_FOUND )
    else()
      find_package( Python  ${_p_VERSION} COMPONENTS Interpreter Development ${_p_REQUIRED} )
      set( __required_vars Python_FOUND Python_Interpreter_FOUND Python_Development_FOUND )
    endif()

    if( Python_Interpreter_FOUND )
        ecbuild_debug( "ecbuild_find_python: Found Python interpreter version '${Python_VERSION}' at '${Python_EXECUTABLE}'" )
        # python site-packages are located at...
        ecbuild_debug( "ecbuild_find_python: Python_SITELIB=${Python_SITELIB}" )
    else()
        ecbuild_debug( "ecbuild_find_python: could NOT find Python interpreter!" )
    endif()

    find_package_handle_standard_args( Python DEFAULT_MSG ${__required_vars} )

    set( Python_FOUND             ${Python_FOUND} PARENT_SCOPE )
    set( Python_Interpreter_FOUND ${Python_Interpreter_FOUND} PARENT_SCOPE )
    set( Python_Development_FOUND ${Python_Development_FOUND} PARENT_SCOPE )
    set( Python_EXECUTABLE        ${Python_EXECUTABLE} PARENT_SCOPE )
    set( Python_VERSION_MAJOR     ${Python_VERSION_MAJOR} PARENT_SCOPE )
    set( Python_VERSION_MINOR     ${Python_VERSION_MINOR} PARENT_SCOPE )
    set( Python_VERSION_PATCH     ${Python_VERSION_PATCH} PARENT_SCOPE )
    set( Python_VERSION           ${Python_VERSION} PARENT_SCOPE )
    set( Python_INCLUDE_DIRS      ${Python_INCLUDE_DIRS} PARENT_SCOPE )
    set( Python_LIBRARIES         ${Python_LIBRARIES} PARENT_SCOPE )
    set( Python_SITELIB           ${Python_SITELIB} PARENT_SCOPE )

    # To keep backwards compatibility, the old variable names (PYTHON_*) are set as well

    set( PYTHON_FOUND             "${Python_FOUND}" PARENT_SCOPE )
    set( PYTHONINTERP_FOUND       "${Python_Interpreter_FOUND}" PARENT_SCOPE )
    set( PYTHONLIBS_FOUND         "${Python_Development_FOUND}" PARENT_SCOPE )
    set( PYTHON_EXECUTABLE        "${Python_EXECUTABLE}" PARENT_SCOPE )
    set( PYTHON_VERSION_MAJOR     "${Python_VERSION_MAJOR}" PARENT_SCOPE )
    set( PYTHON_VERSION_MINOR     "${Python_VERSION_MINOR}" PARENT_SCOPE )
    set( PYTHON_VERSION_PATCH     "${Python_VERSION_PATCH}" PARENT_SCOPE )
    set( PYTHON_VERSION_STRING    "${Python_VERSION}" PARENT_SCOPE )
    set( PYTHON_INCLUDE_DIRS      "${Python_INCLUDE_DIRS}" PARENT_SCOPE )
    set( PYTHON_LIBRARIES         "${Python_LIBRARIES}" PARENT_SCOPE )
    set( PYTHON_SITE_PACKAGES     "${Python_SITELIB}" PARENT_SCOPE )

endfunction( ecbuild_find_python )
