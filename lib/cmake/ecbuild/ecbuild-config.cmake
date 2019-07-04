# (C) Copyright 2019- ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

get_filename_component(ecbuild_MACROS_DIR ${CMAKE_CURRENT_LIST_DIR}/../../../cmake ABSOLUTE)
cmake_policy( PUSH )
cmake_policy( SET CMP0057 NEW )
if(NOT ${ecbuild_MACROS_DIR} IN_LIST CMAKE_MODULE_PATH)
    list(INSERT CMAKE_MODULE_PATH 0 ${ecbuild_MACROS_DIR})
endif()
cmake_policy( POP )
include(ecbuild)

