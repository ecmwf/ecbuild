cmake_minimum_required( VERSION 3.18 FATAL_ERROR )

find_package( ecbuild REQUIRED )
project( test_add_option VERSION 0.1.0 LANGUAGES NONE )

ecbuild_add_option(FEATURE TEST_A) # should default to ON
ecbuild_add_option(FEATURE TEST_B DEFAULT ON)
ecbuild_add_option(FEATURE TEST_C DEFAULT OFF)

ecbuild_add_option(FEATURE TEST_D REQUIRED_PACKAGES "NAME foo")
ecbuild_add_option(FEATURE TEST_E REQUIRED_PACKAGES "NAME foo" "NAME bar")

set(COND_F TRUE)
ecbuild_add_option(FEATURE TEST_F CONDITION COND_F)
set(COND_G FALSE)
ecbuild_add_option(FEATURE TEST_G CONDITION COND_G)

ecbuild_add_option(FEATURE TEST_H REQUIRED_PACKAGES "foo 1.2" )         # should pass as available is version 1.2.3
ecbuild_add_option(FEATURE TEST_I REQUIRED_PACKAGES "foo VERSION 1.2" ) # should pass as available is version 1.2.3

ecbuild_add_option(FEATURE TEST_J REQUIRED_PACKAGES "foo 2.1" )         # should fail as available is version 1.2.3
ecbuild_add_option(FEATURE TEST_K REQUIRED_PACKAGES "foo VERSION 2.1" ) # should fail as available is version 1.2.3

foreach(var IN ITEMS A B C D E F G H I J K)
  set(expected ${EXPECT_TEST_${var}})
  set(actual ${HAVE_TEST_${var}})
  if(expected AND NOT actual)
    message(SEND_ERROR "HAVE_TEST_${var} = ${actual}, expected 1")
  elseif(actual AND NOT expected)
    message(SEND_ERROR "HAVE_TEST_${var} = ${actual}, expected 0")
  else()
    message("HAVE_TEST_${var} = ${actual} as expected")
  endif()
endforeach()
