# (C) Copyright 2020- JCSDA.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.

##############################################################################
#.rst:
#
# ecbuild_check_urls
# ======================
#
# Check multiple URL validity. ::
#
#   ecbuild_check_urls( NAMES <name1> [ <name2> ... ]
#                           RESULT <result> )
#
# curl or wget is required (curl is preferred if available).
#
# Options
# -------
#
# NAMES : required
#   list of names of the files to check, including the directory structure
#   on the server hosting test files (if available)
#
# RESULT : required
#   check result (0 if all URLs exist, more if not)
#
# Usage
# -----
#
# Check whether files exist on ``<ECBUILD_DOWNLOAD_BASE_URL>/<NAME>``
# for each name given in the list of ``NAMES``.
# ``RESULT`` is set to the number of missing files.
#
# Examples
# --------
#
# Check file ... existence: ::
#
#   ecbuild_check_urls( NAMES test/data/dir/msl1.grib test/data/dir/msl2.grib
#                           RESULT FILES_EXIST )
#
##############################################################################

function(ecbuild_check_urls)

    set( single_value_args RESULT )
    set( multi_value_args  NAMES )

    cmake_parse_arguments( _p "${options}" "${single_value_args}" "${multi_value_args}"  ${_FIRST_ARG} ${ARGN} )

    if(_p_UNPARSED_ARGUMENTS)
      ecbuild_critical("Unknown keywords given to ecbuild_check_url(): \"${_p_UNPARSED_ARGUMENTS}\"")
    endif()

    ### check parameters

    if( NOT _p_NAMES )
      ecbuild_critical("ecbuild_get_test_data() expects a NAMES")
    endif()

    # Allow the user to override the download URL (ECBUILD-447)
    if( NOT DEFINED ECBUILD_DOWNLOAD_BASE_URL )
      set( ECBUILD_DOWNLOAD_BASE_URL http://download.ecmwf.org/test-data )
    endif()

    # Do not retry downloads by default (ECBUILD-307)
    if( NOT DEFINED ECBUILD_DOWNLOAD_RETRIES )
      set( ECBUILD_DOWNLOAD_RETRIES 0 )
    endif()

    # Use default timeout of 30s if not specified (ECBUILD-307)
    if( NOT DEFINED ECBUILD_DOWNLOAD_TIMEOUT )
      set( ECBUILD_DOWNLOAD_TIMEOUT 30 )
    endif()

    # Initialise CODE_SUM
    set( CODE_SUM 0 )
 
    find_program( CURL_PROGRAM curl )
    mark_as_advanced(CURL_PROGRAM)
    if( CURL_PROGRAM )
      # Loop over files
      foreach( NAME ${_p_NAMES} )

        execute_process(
          COMMAND ${CURL_PROGRAM} --silent --head --fail --output /dev/null
                  --retry ${ECBUILD_DOWNLOAD_RETRIES}
                  --connect-timeout ${ECBUILD_DOWNLOAD_TIMEOUT}
	          ${ECBUILD_DOWNLOAD_BASE_URL}/${NAME}
          RESULT_VARIABLE CODE
        )

    else()

      find_program( WGET_PROGRAM wget )
      if( WGET_PROGRAM )
        # Loop over files
        foreach( NAME ${_p_NAMES} )

          # wget takes the total number of tries, curl the number or retries
          math( EXPR ECBUILD_DOWNLOAD_RETRIES "${ECBUILD_DOWNLOAD_RETRIES} + 1" )

          execute_process(
            COMMAND ${WGET_PROGRAM} -O/dev/null -q
                    -t ${ECBUILD_DOWNLOAD_RETRIES} -T ${ECBUILD_DOWNLOAD_TIMEOUT}
	            ${ECBUILD_DOWNLOAD_BASE_URL}/${NAME}
              RESULT_VARIABLE CODE
          )

        else()

          set( CODE 1 )
          if( WARNING_CANNOT_DOWNLOAD_TEST_DATA )
            ecbuild_warn( "Couldn't find curl neither wget -- cannot check URL, set result to 0." )
            set( WARNING_CANNOT_DOWNLOAD_TEST_DATA 1 CACHE INTERNAL "Couldn't find curl neither wget -- cannot check URL, set result to 0" )
            mark_as_advanced( WARNING_CANNOT_DOWNLOAD_TEST_DATA )
          endif()

        endif()

      endif()

      # Add to CODE_SUM
      if( CODE GREATER 0)
        math( EXPR CODE_SUM "${CODE_SUM} + 1" )
      endif()

    endforeach()

    # Set result
    set( ${_p_RESULT} ${CODE_SUM} PARENT_SCOPE )

endfunction(ecbuild_check_urls)
