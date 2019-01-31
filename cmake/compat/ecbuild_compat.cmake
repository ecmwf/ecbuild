# (C) Copyright 2019- ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

####################################################################################################
# include our cmake macros, but only do so if this is the top project
if(ECBUILD_2_COMPAT AND PROJECT_NAME STREQUAL CMAKE_PROJECT_NAME)
  if(ECBUILD_2_COMPAT_DEPRECATE)
    ecbuild_deprecate("The ecbuild 2 compatibility layer is deprecated. "
      "Please upgrade the build system and unset `ECBUILD_2_COMPAT`.")
  endif()

  function(__ecbuild_deprecated_watcher VAR ACCESS)
    if(ACCESS STREQUAL "READ_ACCESS")
      message(DEPRECATION "The Variable '${VAR}' is deprecated! Please use '${ECBUILD_${VAR}_REPLACEMENT}' instead.")
    endif()
  endfunction()

  function(ecbuild_mark_compat OLD_VAR NEW_VAR)
    if(ECBUILD_2_COMPAT_DEPRECATE)
      set(ECBUILD_${OLD_VAR}_REPLACEMENT "${NEW_VAR}" CACHE INTERNAL "${OLD_VAR} is deprecated and was replaced by ${NEW_VAR}" FORCE)
      variable_watch(${OLD_VAR} __ecbuild_deprecated_watcher)
    endif()
  endfunction()

  # use macro to acces value of NEW_VAR
  macro(ecbuild_declare_compat OLD_VAR NEW_VAR)
    if(ECBUILD_2_COMPAT_DEPRECATE)
      ecbuild_mark_compat(${OLD_VAR} ${NEW_VAR})
    endif()
    set(${OLD_VAR} ${${NEW_VAR}})
  endmacro()


  include(ecbuild_compat_require)

  include(ecbuild_define_links_target) # defines the links target
endif()
