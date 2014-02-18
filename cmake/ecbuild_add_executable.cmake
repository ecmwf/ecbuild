# (C) Copyright 1996-2012 ECMWF.
# 
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0. 
# In applying this licence, ECMWF does not waive the privileges and immunities 
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

##############################################################################
# macro for adding a test
##############################################################################

macro( ecbuild_add_executable )

	set( options NOINSTALL AUTO_VERSION )
	set( single_value_args TARGET COMPONENT LINKER_LANGUAGE VERSION )
    set( multi_value_args  SOURCES TEMPLATES LIBS INCLUDES DEPENDS PERSISTENT DEFINITIONS CFLAGS CXXFLAGS FFLAGS GENERATED CONDITION )

    cmake_parse_arguments( _PAR "${options}" "${single_value_args}" "${multi_value_args}"  ${_FIRST_ARG} ${ARGN} )

    if(_PAR_UNPARSED_ARGUMENTS)
      message(FATAL_ERROR "Unknown keywords given to ecbuild_add_executable(): \"${_PAR_UNPARSED_ARGUMENTS}\"")
    endif()

    if( NOT _PAR_TARGET  )
      message(FATAL_ERROR "The call to ecbuild_add_executable() doesn't specify the TARGET.")
    endif()

    if( NOT _PAR_SOURCES )
      message(FATAL_ERROR "The call to ecbuild_add_executable() doesn't specify the SOURCES.")
    endif()

    ### conditional build

    if( DEFINED _PAR_CONDITION )
        set(_target_condition_file "${CMAKE_CURRENT_BINARY_DIR}/set_${_PAR_TARGET}_condition.cmake")
        file( WRITE  ${_target_condition_file} "  if( ")
        foreach( term ${_PAR_CONDITION} )
            file( APPEND ${_target_condition_file} " ${term}")
        endforeach()
        file( APPEND ${_target_condition_file} " )\n    set(_${_PAR_TARGET}_condition TRUE)\n  else()\n    set(_${_PAR_TARGET}_condition FALSE)\n  endif()\n")
        include( ${_target_condition_file} )
    else()
        set( _${_PAR_TARGET}_condition TRUE )
    endif()

    if( _${_PAR_TARGET}_condition )

        # add include dirs if defined
        if( DEFINED _PAR_INCLUDES )
          list(REMOVE_DUPLICATES _PAR_INCLUDES )
          foreach( path ${_PAR_INCLUDES} ) # skip NOTFOUND
            if( path )
              include_directories( ${path} )
    #        else()
    #          message( WARNING "Path ${path} was skipped" )
            endif()
          endforeach()
        endif()
    
        # add persistent layer files
        if( DEFINED _PAR_PERSISTENT )
			if( DEFINED PERSISTENT_NAMESPACE )
	            ecbuild_add_persistent( SRC_LIST _PAR_SOURCES FILES ${_PAR_PERSISTENT} NAMESPACE ${PERSISTENT_NAMESPACE} )
			else()
	            ecbuild_add_persistent( SRC_LIST _PAR_SOURCES FILES ${_PAR_PERSISTENT} )
			endif()
     endif()
    
        # add templates to project files and remove from compilation sources
        if( DEFINED _PAR_TEMPLATES )
            list( REMOVE_ITEM _PAR_SOURCES ${_PAR_TEMPLATES} )
            ecbuild_declare_project_files( ${_PAR_TEMPLATES} )
            add_custom_target( ${_PAR_TARGET}_templates SOURCES ${_PAR_TEMPLATES} )
        endif()
    
        # add the executable target
        add_executable( ${_PAR_TARGET} ${_PAR_SOURCES} )
    
        # add extra dependencies
        if( DEFINED _PAR_DEPENDS)
          add_dependencies( ${_PAR_TARGET} ${_PAR_DEPENDS} )
        endif()
    
        # add the link libraries
        if( DEFINED _PAR_LIBS )
          list(REMOVE_DUPLICATES _PAR_LIBS )
          list(REMOVE_ITEM _PAR_LIBS debug)
          list(REMOVE_ITEM _PAR_LIBS optimized)
          foreach( lib ${_PAR_LIBS} ) # skip NOTFOUND
            if( lib )
              target_link_libraries( ${_PAR_TARGET} ${lib} )
            else()
#              message( WARNING "Lib ${lib} was skipped" )
            endif()
          endforeach()
        endif()
    
        # add local flags
        if( DEFINED _PAR_CFLAGS )
            set_source_files_properties( ${${_PAR_TARGET}_c_srcs}   PROPERTIES COMPILE_FLAGS "${_PAR_CFLAGS}" )
        endif()
        if( DEFINED _PAR_CXXFLAGS )
            set_source_files_properties( ${${_PAR_TARGET}_cxx_srcs} PROPERTIES COMPILE_FLAGS "${_PAR_CXXFLAGS}" )
        endif()
        if( DEFINED _PAR_FFLAGS )
            set_source_files_properties( ${${_PAR_TARGET}_f_srcs}   PROPERTIES COMPILE_FLAGS "${_PAR_FFLAGS}" )
        endif()
        if( DEFINED _PAR_GENERATED )
            set_source_files_properties( ${_PAR_GENERATED} PROPERTIES GENERATED 1 )
        endif()

		# define VERSION if requested
		if( DEFINED _PAR_VERSION )
			set_target_properties( ${_PAR_TARGET} PROPERTIES VERSION "${_PAR_VERSION}" )
		else()
			if( DEFINED _PAR_AUTO_VERSION )
				set_target_properties( ${_PAR_TARGET} PROPERTIES VERSION "${${PNAME}_MAJOR_VERSION}.${${PNAME}_MINOR_VERSION}" )
			endif()
		endif()
    
        # filter sources        

        ecbuild_separate_sources( TARGET ${_PAR_TARGET} SOURCES ${_PAR_SOURCES} )

#    debug_var( ${_PAR_TARGET}_h_srcs )
#    debug_var( ${_PAR_TARGET}_c_srcs )
#    debug_var( ${_PAR_TARGET}_cxx_srcs )
#    debug_var( ${_PAR_TARGET}_f_srcs )

        # installation

        if( NOT _PAR_NOINSTALL )

            # add installation paths and associate with defined component
#            if( DEFINED _PAR_COMPONENT )
#                set( COMPONENT_DIRECTIVE "${_PAR_COMPONENT}" )
#            else()
#                set( COMPONENT_DIRECTIVE "${PROJECT_NAME}" )
#            endif()
        
            install( TARGETS ${_PAR_TARGET}
              EXPORT  ${CMAKE_PROJECT_NAME}-targets
              RUNTIME DESTINATION ${INSTALL_BIN_DIR}
              LIBRARY DESTINATION ${INSTALL_LIB_DIR}
              ARCHIVE DESTINATION ${INSTALL_LIB_DIR} )
#              COMPONENT ${COMPONENT_DIRECTIVE} )

            # set build location

            set_property( TARGET ${_PAR_TARGET} PROPERTY RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin )

            # export location of target to other projects -- must be exactly after setting the build location (see previous command)

            export( TARGETS ${_PAR_TARGET} APPEND FILE "${TOP_PROJECT_TARGETS_FILE}" )

         endif()
    
        # add definitions to compilation
        if( DEFINED _PAR_DEFINITIONS )
            get_property( _target_defs TARGET ${_PAR_TARGET} PROPERTY COMPILE_DEFINITIONS )
            list( APPEND _target_defs ${_PAR_DEFINITIONS} )
            set_property( TARGET ${_PAR_TARGET} PROPERTY COMPILE_DEFINITIONS ${_target_defs} )
        endif()
        
        # set linker language
        if( DEFINED _PAR_LINKER_LANGUAGE )
            set_property( TARGET ${_PAR_TARGET} PROPERTY LINKER_LANGUAGE ${_PAR_LINKER_LANGUAGE} )
        endif()

        # paths to target
        get_target_property(EXE_FILENAME ${_PAR_TARGET} OUTPUT_NAME)
        if( NOT EXE_FILENAME )
            set( EXE_FILENAME ${_PAR_TARGET} )
        endif()

        # make sure target is removed before - some problems with AIX
        add_custom_command(
              TARGET ${_PAR_TARGET}
              PRE_BUILD
              COMMAND ${CMAKE_COMMAND} -E remove ${EXE_FILENAME}
        )
    
        # for the links target
        if( NOT _PAR_NOINSTALL )
            ecbuild_link_exe( ${_PAR_TARGET} ${EXE_FILENAME} )
        endif()

        # append to the list of this project targets
        set( ${PROJECT_NAME}_ALL_EXES ${${PROJECT_NAME}_ALL_EXES} ${_PAR_TARGET} CACHE INTERNAL "" )    

    endif()

    # mark project files
    ecbuild_declare_project_files( ${_PAR_SOURCES} )

endmacro( ecbuild_add_executable  )
