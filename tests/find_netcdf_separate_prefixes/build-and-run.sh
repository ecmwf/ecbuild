#!/usr/bin/env bash

set -e

HERE=${CMAKE_CURRENT_BINARY_DIR:-"$( cd $( dirname "${BASH_SOURCE[0]}" ) && pwd -P )"}
SOURCE=${CMAKE_CURRENT_SOURCE_DIR:-$HERE}

# Add ecbuild to path
export PATH=$SOURCE/../../bin:$PATH

# netCDF C and C++ installed in separate prefixes; FindNetCDF only looks for the files
rm -rf $HERE/netcdf-c $HERE/netcdf-cxx
mkdir -p $HERE/netcdf-c/include $HERE/netcdf-c/lib $HERE/netcdf-cxx/include $HERE/netcdf-cxx/lib
touch $HERE/netcdf-c/include/netcdf.h $HERE/netcdf-c/lib/libnetcdf.a
touch $HERE/netcdf-cxx/include/netcdf $HERE/netcdf-cxx/lib/libnetcdf_c++4.a

# The project fails to configure unless NetCDF::NetCDF_CXX links NetCDF::NetCDF_C
ecbuild $SOURCE/test_project -B $HERE/build \
  -DNetCDF_C_ROOT=$HERE/netcdf-c -DNetCDF_CXX_ROOT=$HERE/netcdf-cxx
