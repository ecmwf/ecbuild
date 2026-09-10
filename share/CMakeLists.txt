# SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
# SPDX-License-Identifier: Apache-2.0

# ecbuild_add_resources( TARGET ecbuild_share
#	SOURCE_PACK ecmwf_license_header.txt
#	DONT_PACK_DIRS ecbuild )

# install( DIRECTORY ecbuild/toolchains USE_SOURCE_PERMISSIONS DESTINATION ${INSTALL_DATA_DIR} )
install( DIRECTORY ecbuild/check_linker DESTINATION ${INSTALL_DATA_DIR} )
