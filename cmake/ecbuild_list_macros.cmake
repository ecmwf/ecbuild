# (C) Copyright 1996-2012 ECMWF.
# 
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0. 
# In applying this licence, ECMWF does not waive the privileges and immunities 
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

function(JOIN _listname _glue _output )

	set( _return "" )

	foreach( VAL ${${_listname}} )
		set(_return "${_return}${_glue}${VAL}")
	endforeach()

	string(LENGTH "${_glue}" _glue_len)
	string(LENGTH "${_return}" _return_len)

	math(EXPR _return_len ${_return_len}-${_glue_len})
	string(SUBSTRING "${_return}" ${_glue_len} ${_return_len} _return)

	set(${_output} "${_return}" PARENT_SCOPE)

endfunction()

