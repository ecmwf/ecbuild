set(projectB_FOO spam)

if(TARGET libB)
  message(FATAL_ERROR "libB should not be defined yet")
else()
  message("libB not defined yet, as expected")
endif()
