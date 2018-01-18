# (C) Copyright 1996 ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation
# nor does it submit to any jurisdiction.

list( APPEND ecbuild_bin_files
ecbuild
git-meld
git-mproj
check_install.sh 
apply_license.sh
license.pl )

add_custom_target( ecbuild_bin SOURCES ${ecbuild_bin_files} )

install( PROGRAMS ecbuild DESTINATION ${INSTALL_BIN_DIR} )

#	install( PROGRAMS ${ecbuild_bin_files} DESTINATION ${INSTALL_BIN_DIR} )
