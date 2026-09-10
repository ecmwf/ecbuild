# SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
# SPDX-License-Identifier: Apache-2.0

# define project paths

file( MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/bin )
file( MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/lib )

#######################################################################################################

# setup library building rpaths (both in build dir and then when installed)

# add the automatic parts to RPATH which point to dirs outside build tree
set( CMAKE_INSTALL_RPATH_USE_LINK_PATH   TRUE  )

# use RPATHs for the build tree
set( CMAKE_SKIP_BUILD_RPATH              FALSE )

# build with *relative* rpaths by default
if( ENABLE_RELATIVE_RPATHS )
    set( CMAKE_BUILD_WITH_INSTALL_RPATH  TRUE )
else()
    # in case the RPATH is absolute, the install RPATH cannot be set
    # at build-time since it breaks the build tree dynamic links
    set( CMAKE_BUILD_WITH_INSTALL_RPATH  FALSE )
endif()

# put the include dirs which are in the source or build tree
# before all other include dirs, so the headers in the sources
# are prefered over the already installed ones (since cmake 2.4.1)
set( CMAKE_INCLUDE_DIRECTORIES_PROJECT_BEFORE ON )
