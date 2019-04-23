# (C) Copyright 2011- ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation
# nor does it submit to any jurisdiction.

# - Try to find the rpc library
# Once done this will define
#
# RPC_FOUND - system has rpc
# RPC_INCLUDE_DIRS - the rpc include directory
# RPC_LIBRARIES - Link these to use rpc
#


# first check - if the relevant symbols exist without bringing in any additional
# libraries then we don't need to do anything very much

check_symbol_exists (xdr_pointer rpc/xdr.h HAVE_XDR_SYMBOLS)

if(HAVE_XDR_SYMBOLS OR APPLE)
    set(RPC_FOUND 1)
    set(RPC_INCLUDE_DIRS "")
    set(RPC_LIBRARIES "")
else()
    if( NOT RPC_PATH )
        if ( NOT "$ENV{RPC_PATH}" STREQUAL "" )
            set( RPC_PATH "$ENV{RPC_PATH}" )
        elseif ( NOT "$ENV{RPC_DIR}" STREQUAL "" )
            set( RPC_PATH "$ENV{RPC_DIR}" )
        endif()
    endif()

    find_path(RPC_INCLUDE_DIR NAMES rpc/rpc.h PATHS ${RPC_PATH} ${RPC_PATH}/include /usr/include /usr/include/tirpc NO_DEFAULT_PATH )
    find_library(RPC_LIBRARY  NAMES rpc tirpc PATHS ${RPC_PATH} ${RPC_PATH}/lib /lib64 /usr/lib64 /lib /usr/lib   NO_DEFAULT_PATH )


    # handle the QUIETLY and REQUIRED arguments and set RPC_FOUND
    include(FindPackageHandleStandardArgs)
    find_package_handle_standard_args(RPC  DEFAULT_MSG
                                      RPC_LIBRARY RPC_INCLUDE_DIR)

    set( RPC_LIBRARIES    ${RPC_LIBRARY} )
    set( RPC_INCLUDE_DIRS ${RPC_INCLUDE_DIR} )

    mark_as_advanced( RPC_INCLUDE_DIR RPC_LIBRARY )
endif()
