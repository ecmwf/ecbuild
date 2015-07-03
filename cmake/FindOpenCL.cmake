# - Try to find OpenCL
# Once done this will define
#
#  OPENCL_FOUND         - system has OpenCL
#  OPENCL_INCLUDE_DIRS  - the OpenCL include directory
#  OPENCL_LIBRARIES     - link these to use OpenCL

if( $ENV{OPENCL_ROOT} )
	list( APPEND __OPENCL_PATHS $ENV{OPENCL_ROOT} )
endif()

if( OPENCL_ROOT )
	list( APPEND __OPENCL_PATHS ${OPENCL_ROOT} )
endif()

if(UNIX)
  if(APPLE)

    find_path(OPENCL_INCLUDE_DIRS OpenCL/cl.h PATHS ${___OPENCL_PATHS} PATH_SUFFIXES include NO_DEFAULT_PATH)
    find_path(OPENCL_INCLUDE_DIRS OpenCL/cl.h PATHS ${___OPENCL_PATHS} PATH_SUFFIXES include )

    find_library(OPENCL_LIBRARIES OpenCL PATHS ${___OPENCL_PATHS} PATH_SUFFIXES lib NO_DEFAULT_PATH)
    find_library(OPENCL_LIBRARIES OpenCL PATHS ${___OPENCL_PATHS} PATH_SUFFIXES lib )

  else()

    list( APPEND __OPENCL_PATHS /usr/local/cuda )

    if( CUDA_ROOT )
      list( APPEND __OPENCL_PATHS ${CUDA_ROOT} )
    endif()

    find_path(OPENCL_INCLUDE_DIRS NAMES CL/cl.h CL/opencl.h PATHS ${___OPENCL_PATHS} PATH_SUFFIXES include NO_DEFAULT_PATH)
    find_path(OPENCL_INCLUDE_DIRS NAMES CL/cl.h CL/opencl.h PATHS ${___OPENCL_PATHS} PATH_SUFFIXES include )

    find_library(OPENCL_LIBRARIES OpenCL PATHS ${___OPENCL_PATHS} PATH_SUFFIXES lib NO_DEFAULT_PATH)
    find_library(OPENCL_LIBRARIES OpenCL PATHS ${___OPENCL_PATHS} PATH_SUFFIXES lib )

  endif()

endif()

include(FindPackageHandleStandardArgs)

find_package_handle_standard_args( OPENCL DEFAULT_MSG
                                   OPENCL_LIBRARIES OPENCL_INCLUDE_DIRS )

mark_as_advanced( OPENCL_INCLUDE_DIRS OPENCL_LIBRARIES )
