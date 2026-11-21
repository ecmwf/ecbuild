cmake_minimum_required( VERSION 3.18 FATAL_ERROR )

find_package( ecbuild REQUIRED )
project( test_find_netcdf_separate_prefixes VERSION 0.1.0 LANGUAGES C )

# Twice, as projects and their dependencies do
find_package( NetCDF REQUIRED COMPONENTS C CXX )
find_package( NetCDF REQUIRED COMPONENTS C CXX )

get_target_property( _links NetCDF::NetCDF_CXX INTERFACE_LINK_LIBRARIES )
list( FILTER _links INCLUDE REGEX "^NetCDF::NetCDF_C$" )
list( LENGTH _links _n )
if( NOT _n EQUAL 1 )
  message( FATAL_ERROR "NetCDF::NetCDF_CXX links NetCDF::NetCDF_C ${_n} times, expected once" )
endif()
