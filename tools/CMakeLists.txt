# SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
# SPDX-License-Identifier: Apache-2.0

list( APPEND ecbuild_bin_files
ecbuild
git-meld
git-mproj
check_install.sh )

add_custom_target( ecbuild_bin SOURCES ${ecbuild_bin_files} )

install( PROGRAMS ecbuild DESTINATION ${INSTALL_BIN_DIR} )

#	install( PROGRAMS ${ecbuild_bin_files} DESTINATION ${INSTALL_BIN_DIR} )
