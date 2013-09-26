# (C) Copyright 1996-2012 ECMWF.
# 
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0. 
# In applying this licence, ECMWF does not waive the privileges and immunities 
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

##############################################################################
# function for downloading test data

function( _download_test_data _p_NAME _p_DIRNAME )

    # TODO: make that 'at ecmwf'
    #if(1)
    #unset(ENV{no_proxy})
    #unset(ENV{NO_PROXY})
    #set(ENV{http_proxy} "http://proxy.ecmwf.int:3333")
    #endif()

    find_program( CURL_PROGRAM curl )

    if( CURL_PROGRAM )

        add_custom_command( OUTPUT ${_p_NAME}
            COMMAND ${CURL_PROGRAM} --silent --show-error --fail --output ${_p_NAME} http://download.ecmwf.org/test-data/${_p_DIRNAME}/${_p_NAME} )

    else()

        find_program( WGET_PROGRAM wget )

        if( WGET_PROGRAM )

           add_custom_command( OUTPUT ${_p_NAME}
               COMMAND ${CURL_PROGRAM} --no-verbose --fail -O ${_p_NAME} http://download.ecmwf.org/test-data/${_p_DIRNAME}/${_p_NAME} )

        endif()

    endif()

endfunction()


##############################################################################
# function for getting test data

function( ecbuild_get_test_data )

    set( options CHECKSUM )
    set( single_value_args TARGET URL NAME DIRNAME MD5 SHA1)
    set( multi_value_args  )

    cmake_parse_arguments( _p "${options}" "${single_value_args}" "${multi_value_args}"  ${_FIRST_ARG} ${ARGN} )

    if(_p_UNPARSED_ARGUMENTS)
      message(FATAL_ERROR "Unknown keywords given to ecbuild_get_test_data(): \"${_p_UNPARSED_ARGUMENTS}\"")
    endif()

    file( RELATIVE_PATH currdir ${CMAKE_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR} )

    ### check parameters

    if( NOT _p_NAME )
      message(FATAL_ERROR "ecbuild_get_test_data() expects a NAME")
    endif()

    if( NOT _p_TARGET )
#      string( REGEX REPLACE "[^A-Za-z0-9_]" "_" _p_TARGET "test_data_${_p_NAME}")
      string( REGEX REPLACE "[^A-Za-z0-9_]" "_" _p_TARGET "${_p_NAME}")
#      set( _p_TARGET ${_p_NAME} )
    endif()

    if( NOT _p_DIRNAME )
      set( _p_DIRNAME ${PROJECT_NAME}/${currdir} )
    endif()

#    debug_var( _p_TARGET )
#    debug_var( _p_NAME )
#    debug_var( _p_URL )
#    debug_var( _p_DIRNAME )

    # download the data

    _download_test_data( ${_p_NAME} ${_p_DIRNAME} )

    # perform the checksum if requested

    set( _deps ${_p_NAME} )

    if( _p_MD5 OR _p_SHA1 )
        set( _p_CHECKSUM 1 )
    endif()

    if( _p_CHECKSUM )

        find_program( MD5SUM md5sum )

        if( MD5SUM AND NOT _p_MD5 AND NOT _p_SHA1) # use remote md5

#            message( STATUS " ---  getting MD5 sum " )

            add_custom_command( OUTPUT ${_p_NAME}.localmd5
                                COMMAND md5sum ${_p_NAME} > ${_p_NAME}.localmd5 )

            add_custom_command(	OUTPUT ${_p_NAME}.ok
                                COMMAND diff ${_p_NAME}.md5 ${_p_NAME}.localmd5 && touch ${_p_NAME}.ok )

            _download_test_data( ${_p_NAME}.md5 ${_p_DIRNAME} )

            list( APPEND _deps ${_p_NAME}.md5 ${_p_NAME}.localmd5 ${_p_NAME}.ok )

        endif()

        if( MD5SUM AND _p_MD5 )

#            message( STATUS " ---  computing MD5 sum [${_p_MD5}]" )

            add_custom_command( OUTPUT ${_p_NAME}.localmd5
                                COMMAND ${MD5SUM} ${_p_NAME} > ${_p_NAME}.localmd5 )

            add_custom_command( OUTPUT ${_p_NAME}.ok
                                COMMAND diff ${_p_NAME}.md5 ${_p_NAME}.localmd5 && touch ${_p_NAME}.ok )

            configure_file( "${ECBUILD_MACROS_DIR}/md5.in" ${_p_NAME}.md5 @ONLY )

            list( APPEND _deps ${_p_NAME}.localmd5 ${_p_NAME}.ok )

        endif()

        if( _p_SHA1 )

            message( STATUS " ---  computing SHA1 sum [${_p_SHA1}]" )

            find_program( SHASUM NAMES sha1sum shasum )
            if( SHASUM )
                add_custom_command( OUTPUT ${_p_NAME}.localsha1
                                    COMMAND ${SHASUM} ${_p_NAME} > ${_p_NAME}.localsha1 )

                add_custom_command( OUTPUT ${_p_NAME}.ok
                                    COMMAND diff ${_p_NAME}.sha1 ${_p_NAME}.localsha1 && touch ${_p_NAME}.ok )

                configure_file( "${ECBUILD_MACROS_DIR}/sha1.in" ${_p_NAME}.sha1 @ONLY )

                list( APPEND _deps ${_p_NAME}.localsha1 ${_p_NAME}.ok )
            endif()

        endif()

    endif()

    add_custom_target( ${_p_TARGET} DEPENDS ${_deps} )

endfunction(ecbuild_get_test_data)
