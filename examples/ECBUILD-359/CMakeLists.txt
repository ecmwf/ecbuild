# File: CMakeLists.txt
cmake_minimum_required(VERSION 2.8.4 FATAL_ERROR)
project(kata CXX)
include(ecbuild_system NO_POLICY_SCOPE)
ecbuild_requires_macro_version(2.7)
ecbuild_declare_project()
ecbuild_use_package(PROJECT bar REQUIRED)
ecbuild_print_summary()
