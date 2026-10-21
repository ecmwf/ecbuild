# SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
# SPDX-License-Identifier: Apache-2.0

##############################################################################
#.rst:
#
# ecbuild_add_cxx11_flags
# =======================
#
# Add cxx11 flags to CXX compilation flags. ::
#
#   ecbuild_add_cxx11_flags()
#
# DEPRECATED. Please set CMAKE_CXX_STANDARD or use target_compile_features
# instead.
#
##############################################################################

macro( ecbuild_add_cxx11_flags )

    if( ECBUILD_2_COMPAT_DEPRECATE )
        ecbuild_deprecate("ecbuild_add_cxx11_flags is deprecated and will be "
            "removed in a future version. Please set CMAKE_CXX_STANDARD or use "
            "target_compile_features instead.")
    endif()

    if( NOT CMAKE_CXX_STANDARD OR CMAKE_CXX_STANDARD LESS 11 )
        set( CMAKE_CXX_STANDARD 11 )
        set( CMAKE_CXX_STANDARD_REQUIRED ON )
    endif()

endmacro( ecbuild_add_cxx11_flags )
