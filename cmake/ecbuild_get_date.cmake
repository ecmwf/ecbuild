# SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
# SPDX-License-Identifier: Apache-2.0

##############################################################################
#.rst:
#
# ecbuild_get_date
# ================
#
# Set the CMake variable ``${DATE}`` to the current date in the form
# YYYY.mm.DD. ::
#
#   ecbuild_get_date( DATE )
#
##############################################################################

macro(ecbuild_get_date RESULT)
    if(UNIX)
        execute_process(COMMAND "date" "+%d/%m/%Y" OUTPUT_VARIABLE ${RESULT})
        string(REGEX REPLACE "(..)/(..)/(....).*" "\\3.\\2.\\1" ${RESULT} ${${RESULT}})
    else()
        ecbuild_error("date not implemented")
    endif()
endmacro(ecbuild_get_date)

##############################################################################
#.rst:
#
# ecbuild_get_timestamp
# =====================
#
# Set the CMake variable ``${TIMESTAMP}`` to the current date and time in the
# form YYYYmmDDHHMMSS. ::
#
#   ecbuild_get_timestamp( TIMESTAMP )
#
##############################################################################

macro(ecbuild_get_timestamp RESULT)
    if(UNIX)
        execute_process(COMMAND "date" "+%Y/%m/%d/%H/%M/%S" OUTPUT_VARIABLE _timestamp)
        string(REGEX REPLACE "(....)/(..)/(..)/(..)/(..)/(..).*" "\\1\\2\\3\\4\\5\\6" ${RESULT} ${_timestamp})
    else()
        ecbuild_warn("This is NOT UNIX - timestamp not implemented")
    endif()
endmacro(ecbuild_get_timestamp)

