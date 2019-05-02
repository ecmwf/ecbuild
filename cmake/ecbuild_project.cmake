if( NOT ECBUILD_PROJECT_INCLUDED )
set( ECBUILD_PROJECT_INCLUDED TRUE )


macro( project _project_name )

  cmake_policy(PUSH)

  cmake_minimum_required(VERSION 3.3 FATAL_ERROR) # for using IN_LIST
  cmake_policy(SET CMP0057 NEW) # for using IN_LIST

  if( ECBUILD_PROJECT_${CMAKE_CURRENT_SOURCE_DIR} OR ECBUILD_PROJECT_${_project_name} )

    include( CMakeParseArguments )
    include( ecbuild_parse_version )
    include( ecbuild_log )
 
    ecbuild_debug( "ecbuild project(${_project_name}) ")

    set( options "" )
    set( oneValueArgs VERSION )
    set( multiValueArgs "" )

    cmake_parse_arguments( _ecbuild_${_project_name} "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )

    set( CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake" ${CMAKE_MODULE_PATH} )

    if( _ecbuild_${_project_name}_VERSION )
      ecbuild_parse_version( "${_ecbuild_${_project_name}_VERSION}" PREFIX ${_project_name} )
    elseif( EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/VERSION )
      ecbuild_parse_version_file( "VERSION" PREFIX ${_project_name} )
    elseif( EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/VERSION.cmake )
      set( PROJECT_NAME ${_project_name} )
      include( ${CMAKE_CURRENT_SOURCE_DIR}/VERSION.cmake )
      if( ${_project_name}_VERSION_STR )
        if(ECBUILD_2_COMPAT)
          if(ECBUILD_2_COMPAT_DEPRECATE)
            ecbuild_deprecate("Please create the file\n\t${CMAKE_CURRENT_SOURCE_DIR}/VERSION\ncontaining the version string '${${_project_name}_VERSION_STR}'")
          endif()
        else()
          ecbuild_critical("Please create the file\n\t${CMAKE_CURRENT_SOURCE_DIR}/VERSION\ncontaining the version string '${${_project_name}_VERSION_STR}'")
        endif()
        ecbuild_parse_version( "${${_project_name}_VERSION_STR}" PREFIX ${_project_name} )
        endif()
    endif()

    unset( _require_LANGUAGES )
    foreach( _lang C CXX Fortran )
      if( ${_lang} IN_LIST _ecbuild_${_project_name}_UNPARSED_ARGUMENTS )
        set( _require_LANGUAGES TRUE )
      endif()
    endforeach()
    if( _require_LANGUAGES AND NOT "LANGUAGES" IN_LIST _ecbuild_${_project_name}_UNPARSED_ARGUMENTS )
      if(ECBUILD_2_COMPAT)
        if(ECBUILD_2_COMPAT_DEPRECATE)
          ecbuild_deprecate( "Please specify LANGUAGES keyword in project()" )
        endif()
      else()
        ecbuild_critical( "Please specify LANGUAGES keyword in project()" )
      endif()
      list( INSERT _ecbuild_${_project_name}_UNPARSED_ARGUMENTS 0 "LANGUAGES" )
    endif()
    
    if( ${_project_name}_VERSION_STR )
      cmake_policy(SET CMP0048 NEW )
      _project( ${_project_name} VERSION ${${_project_name}_VERSION} ${_ecbuild_${_project_name}_UNPARSED_ARGUMENTS} )
    else()
      cmake_policy(SET CMP0048 OLD )
      _project( ${_project_name} ${_ecbuild_${_project_name}_UNPARSED_ARGUMENTS} )
    endif()

    unset( _ecbuild_${_project_name}_VERSION )

    include( ecbuild_system NO_POLICY_SCOPE )

    ecbuild_declare_project()

    else()

      ecbuild_debug( "CMake project(${_project_name}) ")

      unset( _args )
      foreach( arg ${ARGN} )
        list(APPEND _args ${arg} )
      endforeach()

      if( VERSION IN_LIST _args )
        cmake_policy(SET CMP0048 NEW )
      else()
        cmake_policy(SET CMP0048 OLD )
      endif()

      _project( ${_project_name} ${ARGN} )

  endif()

  cmake_policy(POP)

endmacro()

macro( ecbuild_project _project_name )
  set( ECBUILD_PROJECT_${_project_name} TRUE )
endmacro()


endif()
