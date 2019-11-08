# Specify "HDF5_ROOT" in environment (tested with CMake 3.15)

# Known issues:
# -------------
#
# 1. CMake 3.15 in combination with Cray did not work for Fortran
#       due to captilization in "HDF5.mod" file
#       Workaround:
#         - either create a symlink from "hdf5.mod" to "HDF5.mod" in the
#           local hdf5 installation,
#         - or append "HDF5.mod" to HDF5_INCLUDE_FILENAME in CMake's
#           FindHDF5.cmake file where Fortran is being searched
#
# 2. CMake 3.15 is missing "libhdf5.so" in ${HDF5_C_HL_LIBRARIES}
#       Workaround:
#          - either use both ${HDF5_C_LIBRARIES} and ${HDF5_C_HL_LIBRARIES}
#            in your CMake project
#          - or append "hdf5" to "HDF5_C_HL_LIBRARY_NAMES" in CMake's
#            FindHDF5.cmake file.
#
# Upstream CMake pull request has been submitted here addressing both issues
#    https://gitlab.kitware.com/cmake/cmake/merge_requests/3918
# with fixes hopefully available in 3.16

cmake_minimum_required(VERSION 3.6 FATAL_ERROR)
find_package( ecbuild 3.0.0 REQUIRED )
project( find_hdf5 VERSION 0.0.0 LANGUAGES C Fortran )

find_package( HDF5 REQUIRED COMPONENTS C HL Fortran )

ecbuild_info( "HDF5_FOUND                : ${HDF5_FOUND}" )
ecbuild_info( "HDF5_VERSION              : ${HDF5_VERSION}" )
ecbuild_info( "HDF5_LIBRARIES            : ${HDF5_LIBRARIES}" )
ecbuild_info( "HDF5_INCLUDE_DIRS         : ${HDF5_INCLUDE_DIRS}" )
ecbuild_info( "HDF5_DEFINITIONS          : ${HDF5_DEFINITIONS}" )

ecbuild_info( "HDF5_HL_FOUND             : ${HDF5_HL_FOUND}" )
ecbuild_info( "HDF5_HL_LIBRARIES         : ${HDF5_HL_LIBRARIES}" )
ecbuild_info( "HDF5_C_HL_LIBRARIES       : ${HDF5_C_HL_LIBRARIES}" )
ecbuild_info( "HDF5_Fortran_HL_LIBRARIES : ${HDF5_Fortran_HL_LIBRARIES}" )

ecbuild_info( "HDF5_C_FOUND              : ${HDF5_C_FOUND}" )
ecbuild_info( "HDF5_C_LIBRARIES          : ${HDF5_C_LIBRARIES}" )
ecbuild_info( "HDF5_C_INCLUDE_DIRS       : ${HDF5_C_INCLUDE_DIRS}" )
ecbuild_info( "HDF5_C_DEFINITIONS        : ${HDF5_C_DEFINITIONS}" )

ecbuild_info( "HDF5_Fortran_FOUND        : ${HDF5_Fortran_FOUND}" )
ecbuild_info( "HDF5_Fortran_LIBRARIES    : ${HDF5_Fortran_LIBRARIES}" )
ecbuild_info( "HDF5_Fortran_INCLUDE_DIRS : ${HDF5_Fortran_INCLUDE_DIRS}" )
ecbuild_info( "HDF5_Fortran_DEFINITIONS  : ${HDF5_Fortran_DEFINITIONS}" )

ecbuild_info( "HDF5_IS_PARALLEL          : ${HDF5_IS_PARALLEL}" )


ecbuild_add_test( TARGET   test_hdf5_c
                  SOURCES  hdf5_examples/h5_subset.c
                  LIBS     ${HDF5_C_LIBRARIES}
                  INCLUDES ${HDF5_C_INCLUDE_DIRS} )

ecbuild_add_test( TARGET    test_hdf5_f90
                  SOURCES   hdf5_examples/h5_subset.f90
                  LIBS      ${HDF5_Fortran_LIBRARIES}
                  INCLUDES  ${HDF5_Fortran_INCLUDE_DIRS}
                  CONDITION HDF5_Fortran_FOUND )

ecbuild_add_test( TARGET   test_hdf5_hl_c
                  SOURCES  hdf5_examples/hl_ex_lite1.c
                  LIBS     ${HDF5_C_HL_LIBRARIES}
                  INCLUDES ${HDF5_C_INCLUDE_DIRS} )

ecbuild_add_test( TARGET   test_hdf5_hl_f90
                  SOURCES  hdf5_examples/hl_exlite.f90
                  LIBS     ${HDF5_Fortran_HL_LIBRARIES}
                  INCLUDES ${HDF5_Fortran_INCLUDE_DIRS}
                  CONDITION HDF5_Fortran_FOUND )
