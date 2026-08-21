# (C) Copyright 2019- ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

if( NOT ECBUILD_PROJECT_${CMAKE_CURRENT_SOURCE_DIR} )
set( ECBUILD_PROJECT_${CMAKE_CURRENT_SOURCE_DIR} TRUE )

########################################################################################################
# compatibility with ecbuild 2

if ( NOT DEFINED ECBUILD_2_COMPAT_VALUE )
    set( ECBUILD_2_COMPAT_VALUE OFF )
endif()
if ( NOT DEFINED ECBUILD_2_COMPAT_DEPRECATE_VALUE )
    set( ECBUILD_2_COMPAT_DEPRECATE_VALUE ON )
endif()

option( ECBUILD_2_COMPAT "Keep compatibility with ecbuild 2" ${ECBUILD_2_COMPAT_VALUE} )
option( ECBUILD_2_COMPAT_DEPRECATE "Emit deprecation warnings in the compatibility layer" ${ECBUILD_2_COMPAT_DEPRECATE_VALUE} )

if( ECBUILD_2_COMPAT_DEPRECATE )

    #
    # Since CMake 4.4, CMP0218 policy changes how to control the behaviour of deprecated features.
    #
    # Note: CMAKE_WARN_DEPRECATED and CMAKE_ERROR_DEPRECATED variables are ignored
    #       and CMD_DEPRECATED diagnostic state is used instead.
    cmake_policy( PUSH )
    if( POLICY CMP0218 )
        cmake_policy( SET CMP0218 NEW )
    endif()

    #
    # Set the deprecation severity level -- this inline macro is used only here
    #
    # This allows to workaround the deprecation warnings in CMake 4.4+ and keep compatibility with older versions.
    # It considers if cmake_diagnostic command (CMake 4.4+) is available, to set either CMD_DEPRECATED or
    # CMAKE_WARN_DEPRECATED/CMAKE_ERROR_DEPRECATED variables.
    #
    # Options
    # -------
    #
    # SEVERITY : required
    #   deprecation severity level ("IGNORE", "WARN", "ERROR")
    #
    #   Note: cmake_diagnostic (CMake 4.4+) does not accept "ERROR" as a diagnostic action; the accepted
    #         actions are IGNORE, WARN, SEND_ERROR and FATAL_ERROR. "ERROR" is thus mapped to SEND_ERROR,
    #         which matches the CMAKE_ERROR_DEPRECATED semantics used on older versions.
    #
    macro(ecbuild_set_deprecation_severity SEVERITY)
        if(NOT "${SEVERITY}" MATCHES "^(IGNORE|WARN|ERROR)$")
            message(FATAL_ERROR "Unknown deprecation severity: ${SEVERITY}")
        endif()

        if(COMMAND cmake_diagnostic)
            if("${SEVERITY}" STREQUAL "ERROR")
                cmake_diagnostic(SET CMD_DEPRECATED SEND_ERROR)
            else()
                cmake_diagnostic(SET CMD_DEPRECATED ${SEVERITY})
            endif()
        elseif("${SEVERITY}" STREQUAL "IGNORE")
            set(CMAKE_WARN_DEPRECATED OFF)
            set(CMAKE_ERROR_DEPRECATED OFF)
        elseif("${SEVERITY}" STREQUAL "WARN")
            set(CMAKE_WARN_DEPRECATED ON)
            set(CMAKE_ERROR_DEPRECATED OFF)
        elseif("${SEVERITY}" STREQUAL "ERROR")
            set(CMAKE_WARN_DEPRECATED ON)
            set(CMAKE_ERROR_DEPRECATED ON)
        endif()
    endmacro()

    #
    # Set the deprecation severity level to WARN by default.
    #
    ecbuild_set_deprecation_severity( "WARN" )

    cmake_policy( POP )

endif()

########################################################################################################

include( ecbuild_project )

########################################################################################################

endif()
