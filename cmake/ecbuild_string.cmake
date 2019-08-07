# (C) Copyright 2019- ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

##############################################################################
#.rst:
#
# ecbuild_string
# ==============
#
# Perform various string operations, extending CMake string command. ::
#
#   ecbuild_string(REGEX ESCAPE <string> <output_variable>)
#
##############################################################################
function(ecbuild_string command)

    if("${command}" STREQUAL "REGEX")

        if(NOT ARGC GREATER 1)
            message(SEND_ERROR "ecbuild_string(REGEX) missing sub-command")
            return()
        endif()

        set(subcommand "${ARGV1}")
        if("${subcommand}" STREQUAL "ESCAPE")

            if(NOT ARGC EQUAL 4)
                message(SEND_ERROR "ecbuild_string(REGEX REPLACE) needs exactly 2 arguments")
                return()
            endif()

            #string(REGEX REPLACE "[.*+?|()\\[\\]\\\\^$]" "\\\\\\0" output "${ARGV2}")
            string(REGEX REPLACE "[][.*+?|()\\^$]" "\\\\\\0" output "${ARGV2}")
            set(${ARGV3} "${output}" PARENT_SCOPE)

        endif()

    else()

        message(SEND_ERROR "Unknown command ecbuild_string(${command})")

    endif()

endfunction(ecbuild_string)
