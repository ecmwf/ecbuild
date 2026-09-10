# SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
# SPDX-License-Identifier: Apache-2.0

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
