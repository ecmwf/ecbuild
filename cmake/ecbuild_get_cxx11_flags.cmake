# (C) Copyright 2011- ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation
# nor does it submit to any jurisdiction.

##############################################################################
#.rst:
#
# ecbuild_get_cxx11_flags
# =======================
#
# Set the CMake variable ``${CXX11_FLAGS}`` to the C++11 flags for the current
# compiler (based on macros from https://github.com/UCL/GreatCMakeCookOff). ::
#
#   ecbuild_get_cxx11_flags( CXX11_FLAGS )
#
##############################################################################

function( ecbuild_get_cxx11_flags CXX11_FLAGS )

  include(CheckCXXCompilerFlag)

  check_cxx_compiler_flag(-std=c++11 has_std_cpp11)
  check_cxx_compiler_flag(-std=c++0x has_std_cpp0x)
  check_cxx_compiler_flag(-hstd=c++11 has_hstd_cpp11)
  if(MINGW)
    check_cxx_compiler_flag(-std=gnu++11 has_std_gnupp11)
    check_cxx_compiler_flag(-std=gnu++0x has_std_gnupp0x)
  endif(MINGW)
  if(has_std_gnupp11)
    set(${CXX11_FLAGS} "-std=gnu++11" PARENT_SCOPE)
  elseif(has_std_gnupp0x)
    set(${CXX11_FLAGS} "-std=gnu++0x" PARENT_SCOPE)
  elseif(has_hstd_cpp11)
    set(${CXX11_FLAGS} "-hstd=c++11" PARENT_SCOPE)
  elseif(has_std_cpp11)
    set(${CXX11_FLAGS} "-std=c++11" PARENT_SCOPE)
  elseif(has_std_cpp0x)
    set(${CXX11_FLAGS} "-std=c++0x" PARENT_SCOPE)
  else()
    ecbuild_critical("Could not detect C++11 flags")
  endif(has_std_gnupp11)

endfunction()
