# (C) Copyright 2011- ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation
# nor does it submit to any jurisdiction.

cmake_minimum_required( VERSION 3.18 FATAL_ERROR )

find_package(ecbuild REQUIRED)
project( config_bundle VERSION 0.1 LANGUAGES C )

ecbuild_bundle_initialize()

# Use command "make update" to update branches to latest develop version
ecbuild_bundle( PROJECT subproj1 )
ecbuild_bundle( PROJECT subproj2 )

# Finalize
ecbuild_bundle_finalize()
