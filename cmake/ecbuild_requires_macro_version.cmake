# SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
# SPDX-License-Identifier: Apache-2.0

##############################################################################
#.rst:
#
# ecbuild_requires_macro_version
# ==============================
#
# Check that the ecBuild version satisfied a given minimum version or fail. ::
#
#   ecbuild_requires_macro_version( <minimum-version> )
#
##############################################################################

macro( ecbuild_requires_macro_version req_vrs )

    if( ecbuild_VERSION VERSION_LESS ${req_vrs} )
        ecbuild_critical( "${PROJECT_NAME} needs ecbuild macro version >= ${req_vrs}" )
    endif()

endmacro()
