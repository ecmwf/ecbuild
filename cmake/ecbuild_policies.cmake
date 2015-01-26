# (C) Copyright 1996-2014 ECMWF.
# 
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0. 
# In applying this licence, ECMWF does not waive the privileges and immunities 
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

# for macosx use @rpath in a target’s install name

if( POLICY CMP0042 )
	cmake_policy( SET CMP0042 NEW )
	set( CMAKE_MACOSX_RPATH ON )
endif()

# inside if() don't dereference variables if they are quoted 
# e.g. "VAR" is not dereferenced 
#      "${VAR}" is dereference only once

if( POLICY CMP0054 )
	cmake_policy( SET CMP0054 NEW )
endif()
