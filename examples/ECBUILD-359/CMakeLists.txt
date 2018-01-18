# (C) Copyright 1996 ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation
# nor does it submit to any jurisdiction.

# File: CMakeLists.txt
cmake_minimum_required(VERSION 2.8.4 FATAL_ERROR)
project(kata CXX)
include(ecbuild_system NO_POLICY_SCOPE)
ecbuild_requires_macro_version(2.7)
ecbuild_declare_project()
ecbuild_use_package(PROJECT bar REQUIRED)
ecbuild_print_summary()
