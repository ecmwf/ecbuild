ecbuild_add_option( FEATURE TESTS
					DEFAULT ON
					DESCRIPTION "Enable the unit tests" )

if( ENABLE_TESTS )

	# Try to find compiled boost

	if( BOOST_ROOT OR BOOSTROOT OR DEFINED ENV{BOOST_ROOT} OR DEFINED ENV{BOOSTROOT} )
		set( CMAKE_PREFIX_PATH ${BOOST_ROOT} ${BOOSTROOT} $ENV{BOOST_ROOT} $ENV{BOOSTROOT} ${CMAKE_PREFIX_PATH} )
	endif()

	ecbuild_add_extra_search_paths( boost ) # also respects BOOST_ROOT

	set( Boost_USE_MULTITHREADED  ON )
#   set( Boost_DEBUG              ON )

	find_package( Boost 1.47.0 COMPONENTS unit_test_framework test_exec_monitor )

	set( ECBUILD_BOOST_HEADER_DIRS "${CMAKE_CURRENT_LIST_DIR}/include" )

	if( Boost_FOUND AND Boost_UNIT_TEST_FRAMEWORK_LIBRARY AND Boost_TEST_EXEC_MONITOR_LIBRARY )

		set( BOOST_UNIT_TEST_FRAMEWORK_LINKED 1 )

		# message( STATUS "Boost unit test framework -- FOUND [${Boost_UNIT_TEST_FRAMEWORK_LIBRARY}]" )

	else()

		set( BOOST_UNIT_TEST_FRAMEWORK_HEADER_ONLY 1 )

		list( APPEND ECBUILD_BOOST_HEADER_DIRS "${CMAKE_CURRENT_LIST_DIR}/contrib/boost-1.55/include" )

		# comment out this when ecbuild paks boost unit test inside...
		message( WARNING "Boost unit test framework -- NOT FOUND : deactivating tests, ENABLE_TESTS = OFF" )
		set( ENABLE_TESTS OFF )

	endif()

endif()
