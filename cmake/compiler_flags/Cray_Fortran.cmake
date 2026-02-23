# (C) Copyright 2011- ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation
# nor does it submit to any jurisdiction.

# -emf activates .mods and uses lower case
# -rmoid produces a listing file

if( CMAKE_Fortran_COMPILER_VERSION VERSION_GREATER_EQUAL 18.0.1 )
    # From CCE 18.0.1 onwards, HPE/Cray renamed mod files for Fortran submodules
    # from <submodule_name>.mod to <parent_module_name>.<submodule_name>.smod
    # CMake does not yet (as of v4.2.3) handle this correctly, thus we have to
    # manually inject the correct behaviour here by
    set( CMAKE_Fortran_SUBMODULE_SEP "." )
    set( CMAKE_Fortran_SUBMODULE_EXT ".smod" )
endif()

if( CMAKE_Fortran_COMPILER_VERSION VERSION_GREATER_EQUAL 18.0.0 AND CMAKE_Fortran_COMPILER_VERSION VERSION_LESS 20.0.0 )
    # Unfortunately, CCE 18 and 19 incurred a bug in the lower-casing of
    # submodule .smod files with the above change, leading to incomplete
    # lower-casing of the output file name, e.g., `parent_mod.sUB_MOD.smod`.
    # This is supposedly fixed in CCE20, but we have to switch off the use of
    # the `-ef` option for versions in-between.
    set( _crayftn_mod_options "-em" )
else()
    set( _crayftn_mod_options "-emf" )
endif()

set( CMAKE_Fortran_FLAGS_RELEASE        "${_crayftn_mod_options} -rmoid -N 1023 -O3 -hfp3 -hscalar3 -hvector3 -DNDEBUG"                    CACHE STRING "Release Fortran flags"                 FORCE )
set( CMAKE_Fortran_FLAGS_RELWITHDEBINFO "${_crayftn_mod_options} -rmoid -N 1023 -O2 -hfp1 -g -DNDEBUG"                                     CACHE STRING "Release-with-debug-info Fortran flags" FORCE )
set( CMAKE_Fortran_FLAGS_PRODUCTION     "${_crayftn_mod_options} -rmoid -N 1023 -O2 -hfp1 -g"                                              CACHE STRING "Production Fortran flags"              FORCE )
set( CMAKE_Fortran_FLAGS_BIT            "${_crayftn_mod_options} -rmoid -N 1023 -O2 -hfp1 -g -hflex_mp=conservative -hadd_paren -DNDEBUG"  CACHE STRING "Bit-reproducible Fortran flags"        FORCE )
set( CMAKE_Fortran_FLAGS_DEBUG          "${_crayftn_mod_options} -rmoid -N 1023 -O0 -g"                                                    CACHE STRING "Debug Fortran flags"                   FORCE )
