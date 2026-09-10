# SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
# SPDX-License-Identifier: Apache-2.0

# - Try to find the NAG includes and library
# This module defines
#
#  NAG_FOUND         - System has NAG
#  NAG_INCLUDE_DIRS  - the NAG include directories
#  NAG_LIBRARIES     - the libraries needed to use NAG
#
# The following paths will be searched with priority if set in CMake or env
#
#  NAG_DIR   - root folder of the NAG installation
#  NAG_PATH  - root folder of the NAG installation

find_path( NAG_INCLUDE_DIR nag_precisions.mod
           PATHS ${NAG_PATH} ENV NAG_PATH
                 ${NAG_DIR}  ENV NAG_DIR
           PATH_SUFFIXES include
           NO_DEFAULT_PATH )

find_library( NAG_LIBRARY NAMES nag
              PATHS ${NAG_PATH} ENV NAG_PATH
                    ${NAG_DIR}  ENV NAG_DIR
              PATH_SUFFIXES lib lib64
              NO_DEFAULT_PATH )

set( NAG_LIBRARIES    ${NAG_LIBRARY} )
set( NAG_INCLUDE_DIRS ${NAG_INCLUDE_DIR} )

include(FindPackageHandleStandardArgs)

# handle the QUIETLY and REQUIRED arguments and set NAG_FOUND to TRUE
# if all listed variables are TRUE
find_package_handle_standard_args( NAG DEFAULT_MSG
                                   NAG_LIBRARY NAG_INCLUDE_DIR )

mark_as_advanced( NAG_INCLUDE_DIR NAG_LIBRARY )
