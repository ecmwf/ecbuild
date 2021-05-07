set(projectB_BAR eggs)

if(NOT TARGET libB)
  message(FATAL_ERROR "libB not defined")
else()
  message("libB defined as expected")
endif()
