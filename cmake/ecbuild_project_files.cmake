# (C) Copyright 1996-2012 ECMWF.
# 
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0. 
# In applying this licence, ECMWF does not waive the privileges and immunities 
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

# resert the variable on each configure
set( EC_UNUSED_FILES "" CACHE INTERNAL "unused files" )

##############################################################################
# finds project files and adds them to the passed variable

macro( ecbuild_find_files_recursive aFileList )

list( APPEND ecbuild_project_extensions c cc cpp cxx ) # for the moment skip ( h hh )

# first find all the files in the directory
foreach( aExt ${ecbuild_project_extensions} )

    file( GLOB_RECURSE listFilesWithExt *.${aExt})

    list( LENGTH  listFilesWithExt sizeFilesWithExt )
    if( sizeFilesWithExt GREATER 0 )
      set( ${aFileList} ${${aFileList}} ${listFilesWithExt} )
    endif()

endforeach()

endmacro()

##############################################################################
# finds the unused files on all the project
function( ecbuild_find_project_files )

  ecbuild_find_files_recursive( cwdFiles )

  # this list will be kept
  set( EC_PROJECT_FILES ${EC_PROJECT_FILES} ${cwdFiles} CACHE INTERNAL "" )
  # this list will be progressevely emptied
  set( EC_UNUSED_FILES  ${EC_UNUSED_FILES}  ${cwdFiles} CACHE INTERNAL "" )

endfunction()

##############################################################################
# removed used files from unused list
macro( ecbuild_declare_project_files )

  foreach( AFILE ${ARGV} )

    # debug_var( AFILE )

    get_property( source_gen SOURCE ${AFILE} PROPERTY GENERATED )

    if( NOT source_gen )
    	
		set( thisFileName ${CMAKE_CURRENT_SOURCE_DIR}/${AFILE} )

		# debug_var( thisFileName )

    	# check for existance of all declared files
	    if( EXISTS ${thisFileName} )
    	    list( REMOVE_ITEM EC_UNUSED_FILES ${thisFileName} )
	    else()
			message( FATAL_ERROR "In directory ${CMAKE_CURRENT_SOURCE_DIR} file ${AFILE} was declared in CMakeLists.txt but not found" )
    	endif()
    endif()

  endforeach()

  # rewrite the unused file list in cache
  set( EC_UNUSED_FILES ${EC_UNUSED_FILES} CACHE INTERNAL "unused files" )

endmacro()
