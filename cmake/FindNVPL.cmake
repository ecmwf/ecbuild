# (C) Copyright 2011- ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation
# nor does it submit to any jurisdiction.

# - Try to find NVPL
# Once done this will define
#
#  NVPL_FOUND         - system has Nvidia Performance Libraries
#  NVPL_INCLUDE_DIRS  - the NVPL include directories
#  NVPL_LIBRARIES     - link these to use NVPL
#
# The following paths will be searched with priority if set in CMake or env
#
#  NVPLROOT           - root directory of the NVPL installation
#  NVPL_PATH          - root directory of the NVPL installation
#  NVPL_ROOT          - root directory of the NVPL installation

option( NVPL_PARALLEL "if nvpl shoudl be parallel" OFF )

if( NVPL_PARALLEL )

  set( __nvpl_lib_suffix  "_gomp" )

  find_package(Threads)

else()

  set( __nvpl_lib_suffix "_seq" )

endif()

# Search with priority for NVPLROOT, NVPL_PATH and NVPL_ROOT if set in CMake or env
find_path(NVPL_INCLUDE_DIR nvpl_blas.h
          PATHS ${NVPLROOT} ${NVPL_PATH} ${NVPL_ROOT} $ENV{NVPLROOT} $ENV{NVPL_PATH} $ENV{NVPL_ROOT}
          PATH_SUFFIXES include NO_DEFAULT_PATH)

find_path(NVPL_INCLUDE_DIR_FFTW fftw3.h
          PATH_SUFFIXES include/nvpl_fftw)

if( NVPL_INCLUDE_DIR ) # use include dir to find libs

  set( NVPL_INCLUDE_DIRS ${NVPL_INCLUDE_DIR} ${NVPL_INCLUDE_DIR_FFTW} )


  #  set(CMAKE_FIND_DEBUG_MODE TRUE)
  find_library( NVPL_LIB_BLAS_CORE
                PATHS ${NVPLROOT} ${NVPL_PATH} ${NVPL_ROOT} $ENV{NVPLROOT} $ENV{NVPL_PATH} $ENV{NVPL_ROOT}
		PATH_SUFFIXES "lib" 
                NAMES nvpl_blas_core )

  find_library( NVPL_LIB_BLAS
                PATHS ${NVPLROOT} ${NVPL_PATH} ${NVPL_ROOT} $ENV{NVPLROOT} $ENV{NVPL_PATH} $ENV{NVPL_ROOT}
		PATH_SUFFIXES "lib" 
                NAMES nvpl_blas_lp64${__nvpl_lib_suffix} )

  find_library( NVPL_LIB_FFTW
                PATHS ${NVPLROOT} ${NVPL_PATH} ${NVPL_ROOT} $ENV{NVPLROOT} $ENV{NVPL_PATH} $ENV{NVPL_ROOT}
		PATH_SUFFIXES "lib" 
                NAMES nvpl_fftw )

	#  set(CMAKE_FIND_DEBUG_MODE FALSE)

  if( NVPL_LIB_BLAS_CORE AND NVPL_LIB_BLAS AND NVPL_LIB_FFTW )
      set( NVPL_LIBRARIES ${NVPL_LIB_BLAS_CORE} ${NVPL_LIB_BLAS} ${NVPL_LIB_FFTW}  )
  endif()

endif()

include(FindPackageHandleStandardArgs)

find_package_handle_standard_args( NVPL DEFAULT_MSG
                                   NVPL_LIBRARIES NVPL_INCLUDE_DIRS )

mark_as_advanced( NVPL_INCLUDE_DIR NVPL_LIB_BLAS NVPL_LIB_FFTW )
