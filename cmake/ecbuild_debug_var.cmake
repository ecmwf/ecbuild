# (C) Copyright 1996-2012 ECMWF.
# 
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0. 
# In applying this licence, ECMWF does not waive the privileges and immunities 
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

##############################################################################
# macro for debugging a cmake variable

macro( debug_var VAR )

    message( STATUS "${VAR} [${${VAR}}]" )

endmacro( debug_var )

##############################################################################
# macro for debugging a environment variable within cmake

macro( debug_env_var VAR )

    message( STATUS "ENV ${VAR} [$ENV{${VAR}}]" )

endmacro( debug_env_var )

