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

install( DIRECTORY ecbuild/toolchains DESTINATION ${INSTALL_DATA_DIR} )
