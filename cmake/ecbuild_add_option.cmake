# (C) Copyright 2011- ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

##############################################################################
#.rst:
#
# ecbuild_add_option
# ==================
#
# Add a CMake configuration option, which may depend on a list of packages. ::
#
#   ecbuild_add_option( FEATURE <name>
#                       [ DEFAULT ON|OFF ]
#                       [ DESCRIPTION <description> ]
#                       [ REQUIRED_PACKAGES <package1> [<package2> ...] ]
#                       [ CONDITION <condition> ]
#                       [ ADVANCED ] [ NO_TPL ] )
#
# Options
# -------
#
# FEATURE : required
#   name of the feature / option
#
# DEFAULT : optional, defaults to ON
#   if set to ON, the feature is enabled even if not explicitly requested
#
# DESCRIPTION : optional
#   string describing the feature (shown in summary and stored in the cache)
#
# REQUIRED_PACKAGES : optional
#   list of packages required to be found for this feature to be enabled
#
#   Every item in the list should be a valid argument list for
#   ``ecbuild_find_package``, e.g.::
#
#     "NAME <package> [VERSION <version>] [...]"
#
#   .. note::
#
#     Arguments inside the package string that require quoting need to use the
#     `bracket argument syntax`_ introduced in CMake 3.0 since
#     regular quotes even when escaped are swallowed by the CMake parser.
#
#     Alternatively, the name of a CMake variable containing the string can be
#     passed, which will be expanded by ``ecbuild_find_package``: ::
#
#       set( ECCODES_FAIL_MSG
#            "grib_api can be used instead (select with -DENABLE_ECCODES=OFF)" )
#       ecbuild_add_option( FEATURE ECCODES
#                           DESCRIPTION "Use eccodes instead of grib_api"
#                           REQUIRED_PACKAGES "NAME eccodes REQUIRED FAILURE_MSG ECCODES_FAIL_MSG"
#                           DEFAULT ON )
#
# CONDITION : optional
#   conditional expression which must evaluate to true for this option to be
#   enabled (must be valid in a CMake ``if`` statement)
#
# ADVANCED : optional
#   mark the feature as advanced
#
# NO_TPL : optional
#   do not add any ``REQUIRED_PACKAGES`` to the list of third party libraries
#
# Usage
# -----
#
# Features with ``DEFAULT OFF`` need to be explcitly enabled by the user with
# ``-DENABLE_<FEATURE>=ON``. If a feature is enabled, all ``REQUIRED_PACKAGES``
# are found and ``CONDITION`` is met, ecBuild sets the variable
# ``HAVE_<FEATURE>`` to ``ON``. This is the variable to use to check for the
# availability of the feature.
#
# If a feature is explicitly enabled but the required packages are not found,
# configuration fails. This only applies when configuring from *clean cache*.
# With an already populated cache, use ``-DENABLE_<FEATURE>=REQUIRE`` to make
# the feature a required feature (this cannot be done via the CMake GUI).
#
# .. _bracket argument syntax: https://cmake.org/cmake/help/latest/manual/cmake-language.7.html#bracket-argument
#
##############################################################################

macro( ecbuild_add_option )

  set( options ADVANCED NO_TPL )
  set( single_value_args FEATURE DEFAULT DESCRIPTION TYPE PURPOSE )
  set( multi_value_args REQUIRED_PACKAGES CONDITION )

  cmake_parse_arguments( _p "${options}" "${single_value_args}" "${multi_value_args}"  ${_FIRST_ARG} ${ARGN} )

  if( _p_UNPARSED_ARGUMENTS )
    ecbuild_critical("Unknown keywords given to ecbuild_add_option(): \"${_p_UNPARSED_ARGUMENTS}\"")
  endif()

  # check FEATURE parameter

  if( NOT _p_FEATURE  )
    ecbuild_critical("The call to ecbuild_add_option() doesn't specify the FEATURE.")
  endif()

  # check DEFAULT parameter

  if( NOT DEFINED _p_DEFAULT )
    set( _p_DEFAULT ON )
  else()
    if( NOT _p_DEFAULT MATCHES "[Oo][Nn]" AND NOT _p_DEFAULT MATCHES "[Oo][Ff][Ff]" )
      ecbuild_critical("In macro ecbuild_add_option(), DEFAULT must be either ON or OFF, but found: \"${_p_DEFAULT}\"")
    endif()
  endif()
  ecbuild_debug("ecbuild_add_option(${_p_FEATURE}): defaults to ${_p_DEFAULT}")

  if( _p_PURPOSE  )
    ecbuild_deprecate( "ecbuild_add_option: argument PURPOSE is ignored and will be removed in a future release." )
  endif()
  if( _p_TYPE  )
    ecbuild_deprecate( "ecbuild_add_option: argument TYPE is ignored and will be removed in a future release." )
  endif()

  # check CONDITION parameter
  ecbuild_evaluate_dynamic_condition( _p_CONDITION _${_p_FEATURE}_condition  )

  # Disable deprecation warnings until end of macro, because "ENABLE_<FEATURE>" may already have been
  #   marked with "ecbuild_mark_compat()" in a bundle.
  if( ECBUILD_2_COMPAT )
    set( DISABLE_ECBUILD_DEPRECATION_WARNINGS_orig ${DISABLE_ECBUILD_DEPRECATION_WARNINGS} )
    set( DISABLE_ECBUILD_DEPRECATION_WARNINGS ON )
  endif()

  # Check if user explicitly enabled/disabled the feature in cache
  get_property( _in_cache CACHE ENABLE_${_p_FEATURE} PROPERTY VALUE SET )

  # A feature set to REQUIRE is always treated as explicitly enabled
  if( ENABLE_${_p_FEATURE} MATCHES "REQUIRE" )
    set( ENABLE_${_p_FEATURE} ON CACHE BOOL "" FORCE )
    ecbuild_debug("ecbuild_add_option(${_p_FEATURE}): ENABLE_${_p_FEATURE} was required")
    set( ${_p_FEATURE}_user_provided_input 1 CACHE BOOL "" FORCE )
  elseif( NOT ENABLE_${_p_FEATURE} STREQUAL "" AND _in_cache )
    ecbuild_debug("ecbuild_add_option(${_p_FEATURE}): ENABLE_${_p_FEATURE}=${ENABLE_${_p_FEATURE}} was found in cache")
    set( ${_p_FEATURE}_user_provided_input 1 CACHE BOOL "" )
  else()
    ecbuild_debug("ecbuild_add_option(${_p_FEATURE}): ENABLE_${_p_FEATURE} not found in cache")
    set( ${_p_FEATURE}_user_provided_input 0 CACHE BOOL "" )
  endif()

  mark_as_advanced( ${_p_FEATURE}_user_provided_input )


  # define the option -- for cmake GUI

  option( ENABLE_${_p_FEATURE} "${_p_DESCRIPTION}" ${_p_DEFAULT} )

  ecbuild_debug("ecbuild_add_option(${_p_FEATURE}): defining option ENABLE_${_p_FEATURE} '${_p_DESCRIPTION}' ${_p_DEFAULT}")
  ecbuild_debug("ecbuild_add_option(${_p_FEATURE}): ENABLE_${_p_FEATURE}=${ENABLE_${_p_FEATURE}}")

  # Allow override of ENABLE_<FEATURE> with <PNAME>_ENABLE_<FEATURE> (see ECBUILD-486)
  if( DEFINED ${PNAME}_ENABLE_${_p_FEATURE} )
    ecbuild_debug("ecbuild_add_option(${_p_FEATURE}): found ${PNAME}_ENABLE_${_p_FEATURE}=${${PNAME}_ENABLE_${_p_FEATURE}}")
    # Cache it for future reconfiguration
    set( ${PNAME}_ENABLE_${_p_FEATURE} ${${PNAME}_ENABLE_${_p_FEATURE}} CACHE BOOL "Override for ENABLE_${_p_FEATURE}" )
    # Warn when user provides both ENABLE_<FEATURE> and <PNAME>_ENABLE_<FEATURE>, and explain precedence
    if( ${_p_FEATURE}_user_provided_input )
      ecbuild_warn( "Both ENABLE_${_p_FEATURE} and ${PNAME}_ENABLE_${_p_FEATURE} are set for feature ${_p_FEATURE}."
                    "Using ${PNAME}_ENABLE_${_p_FEATURE}=${${PNAME}_ENABLE_${_p_FEATURE}}" )
    endif()
    # Non-cache (hard) override of ENABLE_<FEATURE> within this project scope only
    set( ENABLE_${_p_FEATURE} ${${PNAME}_ENABLE_${_p_FEATURE}} )
    ecbuild_debug("ecbuild_add_option(${_p_FEATURE}): set ENABLE_${_p_FEATURE} from ${PNAME}_ENABLE_${_p_FEATURE}")
    ecbuild_debug("ecbuild_add_option(${_p_FEATURE}): ENABLE_${_p_FEATURE}=${ENABLE_${_p_FEATURE}}")
  endif()

  ## Update the description of the feature summary
  # Choose the correct tick
  if (ENABLE_${_p_FEATURE})
    set ( _tick "ON")
  else()
    set ( _tick "OFF")
  endif()
  set(_enabled "${ENABLE_${_p_FEATURE}}")
  get_property( _enabled_features GLOBAL PROPERTY ENABLED_FEATURES )
  if( "${_p_FEATURE}" IN_LIST _enabled_features )
    set(_enabled ON)
  endif()

  set( ${PROJECT_NAME}_HAVE_${_p_FEATURE} 0 )

  if( ENABLE_${_p_FEATURE} )
    ecbuild_debug("ecbuild_add_option(${_p_FEATURE}): feature requested to be enabled")

    set( ${PROJECT_NAME}_HAVE_${_p_FEATURE} 1 )

    if( _${_p_FEATURE}_condition )

      ### search for dependent packages

      set( _failed_to_find_packages )  # clear variable
      foreach( pkg ${_p_REQUIRED_PACKAGES} )
        ecbuild_debug("ecbuild_add_option(${_p_FEATURE}): searching for dependent package ${pkg}")

        string(REPLACE " " ";" pkglist ${pkg}) # string to list

        list(GET pkglist 0 pkgfirst)

        if( ECBUILD_2_COMPAT )

          if( pkgfirst STREQUAL "PROJECT" )
            if( ECBUILD_2_COMPAT_DEPRECATE )
              ecbuild_deprecate("Arguments to ecbuild_add_option(REQUIRED_PACKAGES) "
                                "should be valid arguments for ecbuild_find_package")
            endif()
            list(GET pkglist 1 pkgname)
          elseif( pkgfirst STREQUAL "NAME" )
            list(GET pkglist 1 pkgname)
          else()
            set(pkgname ${pkgfirst})
          endif()

          if(${_p_NO_TPL})
            set(_no_tpl NO_TPL)
          else()
            set(_no_tpl)
          endif()

          ecbuild_compat_require(pkgname ${pkg} ${_no_tpl} FEATURE "${_p_FEATURE}" DESCRIPTION "${_p_DESCRIPTION}")

        elseif( pkgfirst STREQUAL "NAME" )
          list(GET pkglist 1 pkgname)
          ecbuild_find_package(${pkglist})
        else()
          set(pkgname ${pkgfirst})
          ecbuild_find_package(${pkglist})
        endif()

        # we have feature if all required packages were FOUND
        if( ${pkgname}_FOUND )
          ecbuild_info( "Found package ${pkgname} required for feature ${_p_FEATURE}" )
        else()
          ecbuild_info( "Could NOT find package ${pkgname} required for feature ${_p_FEATURE} -- ${${pkgname}_HELP_MSG}" )
          set( ${PROJECT_NAME}_HAVE_${_p_FEATURE} 0 )
          list( APPEND _failed_to_find_packages ${pkgname} )
        endif()

      endforeach()
    else( _${_p_FEATURE}_condition )
      set( ${PROJECT_NAME}_HAVE_${_p_FEATURE} 0 )
    endif( _${_p_FEATURE}_condition )

    # FINAL CHECK

    if( ${PROJECT_NAME}_HAVE_${_p_FEATURE} )

      ecbuild_enable_feature( ${_p_FEATURE} )

      ecbuild_info( "Feature ${_p_FEATURE} enabled" )

    else() # if user provided input and we cannot satisfy FAIL otherwise WARN

      ecbuild_disable_unused_feature( ${_p_FEATURE} )

      if( ${_p_FEATURE}_user_provided_input )
        if( NOT _${_p_FEATURE}_condition )
          string(REPLACE ";" " " _condition_msg "${_p_CONDITION}")
          ecbuild_critical( "Feature ${_p_FEATURE} cannot be enabled -- following condition was not met: ${_condition_msg}" )
          set ( _tick "OFF")
        else()
          ecbuild_critical( "Feature ${_p_FEATURE} cannot be enabled -- following required packages weren't found: ${_failed_to_find_packages}" )
          set ( _tick "OFF")
        endif()
      else()
        if( NOT _${_p_FEATURE}_condition )
          string(REPLACE ";" " " _condition_msg "${_p_CONDITION}")
          ecbuild_info( "Feature ${_p_FEATURE} was not enabled (also not requested) -- following condition was not met: ${_condition_msg}" )
          set ( _tick "OFF")
        else()
          ecbuild_info( "Feature ${_p_FEATURE} was not enabled (also not requested) -- following required packages weren't found: ${_failed_to_find_packages}" )
          set ( _tick "OFF")
        endif()
        set( ENABLE_${_p_FEATURE} OFF )
        ecbuild_disable_unused_feature( ${_p_FEATURE} )
      endif()

    endif()

  else()

    ecbuild_info( "Feature ${_p_FEATURE} disabled" )
    set( ${PROJECT_NAME}_HAVE_${_p_FEATURE} 0 )
    ecbuild_disable_unused_feature( ${_p_FEATURE} )

  endif()

  # Retrieve any existing description (n.b. occurs when the same feature is added at multiple projects)
  set(_enabled "${ENABLE_${_p_FEATURE}}")
  get_property( _feature_desc GLOBAL PROPERTY _CMAKE_${_p_FEATURE}_DESCRIPTION )
  # Append the new description
  if( _feature_desc )
    add_feature_info( ${_p_FEATURE} ${_enabled} "${_feature_desc}, ${PROJECT_NAME}(${_tick}): '${_p_DESCRIPTION}'" )
  else()
    add_feature_info( ${_p_FEATURE} ${_enabled} "${PROJECT_NAME}(${_tick}): '${_p_DESCRIPTION}'" )
  endif()

  if( ${_p_ADVANCED} )
    mark_as_advanced( ENABLE_${_p_FEATURE} )
  endif()

  set( HAVE_${_p_FEATURE} ${${PROJECT_NAME}_HAVE_${_p_FEATURE}} )

  if(ECBUILD_2_COMPAT)
    set(ENABLE_${_p_FEATURE} ${ENABLE_${_p_FEATURE}})
    ecbuild_mark_compat(ENABLE_${_p_FEATURE} "HAVE_${_p_FEATURE} or ${PROJECT_NAME}_HAVE_${_p_FEATURE}")

    string( TOUPPER ${PROJECT_NAME} PROJECT_NAME_CAPS )
    if (NOT "${PROJECT_NAME_CAPS}" STREQUAL "${PROJECT_NAME}")
      ecbuild_declare_compat( ${PROJECT_NAME_CAPS}_HAVE_${_p_FEATURE} ${PROJECT_NAME}_HAVE_${_p_FEATURE})
    endif()
  endif()

  if( ECBUILD_2_COMPAT )
    set( DISABLE_ECBUILD_DEPRECATION_WARNINGS ${DISABLE_ECBUILD_DEPRECATION_WARNINGS_orig} )
  endif()

endmacro( ecbuild_add_option  )
