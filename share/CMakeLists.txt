# (C) Copyright 2011- ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation
# nor does it submit to any jurisdiction.

# ecbuild_add_resources( TARGET ecbuild_share
#	SOURCE_PACK ecmwf_license_header.txt
#	DONT_PACK_DIRS ecbuild )

install( DIRECTORY ecbuild/toolchains USE_SOURCE_PERMISSIONS DESTINATION ${INSTALL_DATA_DIR} )
install( DIRECTORY ecbuild/check_linker DESTINATION ${INSTALL_DATA_DIR} )
install( DIRECTORY ecbuild/find_package DESTINATION ${INSTALL_DATA_DIR} )
# Fix permissions
file( GLOB find_files ecbuild/find_package/find_* )
install( FILES ${find_files} DESTINATION ${INSTALL_DATA_DIR}/find_package
  PERMISSIONS
    OWNER_EXECUTE OWNER_READ OWNER_WRITE
    GROUP_EXECUTE GROUP_READ
    WORLD_EXECUTE WORLD_READ )
