cmake_minimum_required( VERSION 3.18 FATAL_ERROR )

find_package(ecbuild 3.4 REQUIRED)

project(projectC VERSION 0.1 LANGUAGES NONE)

find_package(projectA REQUIRED)
find_package(projectB REQUIRED)

set(EXP_projectA_FOO foo)
set(EXP_projectA_BAR bar)
set(EXP_projectB_FOO spam)
set(EXP_projectB_BAR eggs)

foreach(var projectA_FOO projectA_BAR projectB_FOO projectB_BAR)
  if(NOT DEFINED ${var})
    message(FATAL_ERROR "${var} is not defined")
  elseif(NOT ${var} STREQUAL EXP_${var})
    message(FATAL_ERROR "${var}: expected ${EXP_${var}}, got ${${var}}")
  else()
    message( "${var} = ${${var}} as expected")
  endif()
endforeach()
