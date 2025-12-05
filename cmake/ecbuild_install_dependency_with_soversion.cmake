# (C) Copyright 2025- ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

##############################################################################
#.rst:
#
# ecbuild_install_dependency_with_soversion
# =========================================
#
# Installs a third-party dependency that has been found with find_package. ::
#
#   ecbuild_install_dependency_with_soversion( TARGET )
#
#   ``TARGET`` is a cmake target with an IMPORTED_LOCATION property
#
# Use this function to install dependencies that use shared object versioning,
# i.e. install as libxx.so -> libxx.so.1 -> libxx.so.1.2.3. In this case we 
# need to collect soft-links and final shared object.
#
# If your dependency does NOT use shared object versioning, i.e. only installs
# a specific libxx.so, you must use plain CMake to install, e.g.
#
# Example for non-versioned shared objects::
#
#    install(FILES $<TARGET_FILE:TARGET> TYPE LIB)
#
# Be aware that this only installs the dependency itself, no resolution of
# transitive dependencies is applied. Transitive dependencies need to be
# installed explicitly wither with ecbuild_install_dependency_with_soversion()
# or install(...)
#
# Typical usage example::
#
#    if(ENABLE_INSTALL_DEPENDENCIES)
#        ecbuild_install_dependency_with_soversion(libaec::aec)
#    endif()
#
##############################################################################
function(ecbuild_install_dependency_with_soversion _target)
    get_target_property(_loc ${_target} IMPORTED_LOCATION)
    if(NOT _loc)
        message(FATAL_ERROR "Could not find IMPORTED_LOCATION for target ${_target}")
    endif()

    get_filename_component(_dir ${_loc} DIRECTORY)
    get_filename_component(_name ${_loc} NAME)
    string(REGEX REPLACE "\\..*$" "" _base_name "${_name}")

    # Glob for shared libraries with version suffixes
    file(GLOB _files
        "${_dir}/${_base_name}*${CMAKE_SHARED_LIBRARY_SUFFIX}*"
    )

    if(_files)
        install(FILES ${_files} TYPE LIB)
    else()
        message(FATAL_ERROR "No shared libraries found to install for target ${_target}")
    endif()
endfunction()
