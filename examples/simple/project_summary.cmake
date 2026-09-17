# SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
# SPDX-License-Identifier: Apache-2.0

message( STATUS "---------------------------------------------------------" )

if( LAPACK_FOUND )
    ecbuild_info( " LAPACK : [${LAPACK_LIBRARIES}]" )
endif()

if( GSL_FOUND )
    ecbuild_info( " GSL include : [${GSL_INCLUDE_DIRS}]" )
    ecbuild_info( "     libs    : [${GSL_LIBRARIES}]" )
endif()

