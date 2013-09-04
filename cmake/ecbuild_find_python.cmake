# (C) Copyright 1996-2012 ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

############################################################################################
# macro to find python

macro( ecbuild_find_python )

    # parse parameters

    set( options )
    set( single_value_args VERSION )
    set( multi_value_args  )

    cmake_parse_arguments( _PAR "${options}" "${single_value_args}" "${multi_value_args}"  ${_FIRST_ARG} ${ARGN} )

    if(_PAR_UNPARSED_ARGUMENTS)
      message(FATAL_ERROR "Unknown keywords given to ecbuild_find_python(): \"${_PAR_UNPARSED_ARGUMENTS}\"")
    endif()

    # execution

    if( DEFINED _PAR_VERSION )
      find_package( PythonInterp ${_PAR_VERSION} )
      find_package( PythonLibs   ${_PAR_VERSION} )
    else()
      find_package( PythonInterp )
      find_package( PythonLibs   )
    endif()

    # find where python site-packages are ...
    execute_process(COMMAND ${PYTHON_EXECUTABLE} -c "from distutils.sysconfig import get_python_lib; print get_python_lib()" OUTPUT_VARIABLE PYTHON_SITE_PACKAGES OUTPUT_STRIP_TRAILING_WHITESPACE)

    if( PYTHONINTERP_FOUND )
        execute_process( COMMAND ${PYTHON_EXECUTABLE} -V ERROR_VARIABLE _version  RESULT_VARIABLE _return ERROR_STRIP_TRAILING_WHITESPACE)
        if( NOT _return )
            string(REGEX REPLACE ".*([0-9]+)\\.([0-9]+)\\.([0-9]+)" "\\1.\\2.\\3" PYTHON_VERSION ${_version} )
        endif()
    endif()

endmacro( ecbuild_find_python )
