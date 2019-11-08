# (C) Copyright 2011- ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation
# nor does it submit to any jurisdiction.

cmake_minimum_required( VERSION 3.6 FATAL_ERROR )

find_package( ecbuild REQUIRED )
project( cpp_bundle_nested VERSION 0.10.0 LANGUAGES C CXX )

ecbuild_bundle_initialize()

ecbuild_bundle( PROJECT bar )
ecbuild_bundle( PROJECT baz )

ecbuild_bundle_finalize()
