cmake_minimum_required(VERSION 3.11 FATAL_ERROR)
find_package( ecbuild 3.0.0 REQUIRED )
project( find_netcdf VERSION 0.0.0 LANGUAGES C CXX Fortran )

find_package( NetCDF 4 REQUIRED COMPONENTS C CXX CXX_LEGACY Fortran )

set( suffix using_targets )

ecbuild_add_test( TARGET  test_netcdf_cxx_${suffix} 
                  SOURCES netcdf_examples/test_netcdf_cxx.cc
                  LIBS    NetCDF::NetCDF_CXX )

ecbuild_add_test( TARGET  test_netcdf_c_${suffix}
                  SOURCES netcdf_examples/test_netcdf_c.c
                  LIBS    NetCDF::NetCDF_C )

ecbuild_add_test( TARGET  test_netcdf_fortran_${suffix}
                  SOURCES netcdf_examples/test_netcdf_fortran.F90
                  LIBS    NetCDF::NetCDF_Fortran )

ecbuild_add_test( TARGET  test_netcdf_f77_${suffix}
                  SOURCES netcdf_examples/test_netcdf_f77.F
                  LIBS    NetCDF::NetCDF_Fortran )

ecbuild_add_test( TARGET  test_netcdf_cxx_legacy_${suffix}
                  SOURCES netcdf_examples/test_netcdf_cxx_legacy.cc
                  LIBS    NetCDF::NetCDF_CXX_LEGACY )

foreach( NETCDF NetCDF NetCDF4 NETCDF NETCDF4 )

    if( NOT ${NETCDF}_FOUND )
       ecbuild_error( "${NETCDF}_FOUND not set" )
    endif()

    if( NOT ${NETCDF}_INCLUDE_DIRS )
       ecbuild_error( "${NETCDF}_INCLUDE_DIRS not set" )
    endif()

    if( NOT ${NETCDF}_LIBRARIES )
       ecbuild_error( "${NETCDF}_LIBRARIES not set" )
    endif()

    foreach( component C CXX CXX_LEGACY Fortran FORTRAN )
        if( NOT ${NETCDF}_${component}_FOUND )
           ecbuild_error( "${NETCDF}_${component}_FOUND not set" )
        endif()

        if( NOT ${NETCDF}_${component}_INCLUDE_DIRS )
           ecbuild_error( "${NETCDF}_${component}_INCLUDE_DIRS not set" )
        endif()

        if( NOT ${NETCDF}_${component}_LIBRARIES )
           ecbuild_error( "${NETCDF}_${component}_LIBRARIES not set" )
        endif()
    endforeach()

    set( suffix using_vars_${NETCDF} )

    ecbuild_add_test( TARGET   test_netcdf_cxx_${suffix}
                      SOURCES  netcdf_examples/test_netcdf_cxx.cc
                      LIBS     ${${NETCDF}_CXX_LIBRARIES}
                      INCLUDES ${${NETCDF}_INCLUDE_DIRS} )

    ecbuild_add_test( TARGET   test_netcdf_c_${suffix}
                      SOURCES  netcdf_examples/test_netcdf_c.c
                      LIBS     ${${NETCDF}_C_LIBRARIES}
                      INCLUDES ${${NETCDF}_INCLUDE_DIRS} )

    ecbuild_add_test( TARGET   test_netcdf_fortran_${suffix}_Fortran
                      SOURCES  netcdf_examples/test_netcdf_fortran.F90
                      LIBS     ${${NETCDF}_Fortran_LIBRARIES}
                      INCLUDES ${${NETCDF}_INCLUDE_DIRS} )

    ecbuild_add_test( TARGET   test_netcdf_fortran_${suffix}_FORTRAN
                      SOURCES  netcdf_examples/test_netcdf_fortran.F90
                      LIBS     ${${NETCDF}_FORTRAN_LIBRARIES}
                      INCLUDES ${${NETCDF}_INCLUDE_DIRS} )

    ecbuild_add_test( TARGET   test_netcdf_f77_${suffix}_Fortran
                      SOURCES  netcdf_examples/test_netcdf_f77.F
                      LIBS     ${${NETCDF}_Fortran_LIBRARIES}
                      INCLUDES ${${NETCDF}_INCLUDE_DIRS} )

    ecbuild_add_test( TARGET   test_netcdf_f77_${suffix}_FORTRAN
                      SOURCES  netcdf_examples/test_netcdf_f77.F
                      LIBS     ${${NETCDF}_FORTRAN_LIBRARIES}
                      INCLUDES ${${NETCDF}_INCLUDE_DIRS} )

    ecbuild_add_test( TARGET   test_netcdf_cxx_legacy_${suffix}
                      SOURCES  netcdf_examples/test_netcdf_cxx_legacy.cc
                      LIBS     ${${NETCDF}_CXX_LEGACY_LIBRARIES}
                      INCLUDES ${${NETCDF}_INCLUDE_DIRS} )

endforeach()
