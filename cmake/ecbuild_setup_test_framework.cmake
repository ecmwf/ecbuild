ecbuild_add_option( FEATURE TESTS
					DEFAULT ON
					DESCRIPTION "Enable the unit tests" )

if( ENABLE_TESTS )

	# Try to find compiled boost
	# If this is enable then can not find boost libs using env BOOST_ROOT ?
	ecbuild_add_extra_search_paths( boost )

	set(Boost_USE_MULTITHREADED      ON )
	#set(Boost_DEBUG                 ON)

	find_package( Boost 1.47.0 COMPONENTS unit_test_framework test_exec_monitor  )

	if( Boost_FOUND AND Boost_UNIT_TEST_FRAMEWORK_LIBRARY AND Boost_TEST_EXEC_MONITOR_LIBRARY )

		set( EC_BOOST_UNIT_TEST_FRAMEWORK_COMPILED 1 )
		# message( STATUS "using compiled Boost unit test framework [${Boost_UNIT_TEST_FRAMEWORK_LIBRARY}]" )

	else()

		set( EC_BOOST_UNIT_TEST_FRAMEWORK_HEADER_ONLY 1 )
		set( ECBUILD_BOOST_HEADER_DIR "${CMAKE_CURRENT_LIST_DIR}/contrib/boost-1.55/include" )

		message( WARNING "Boost unit test framework not found, deactivating tests -- ENABLE_TESTS = OFF" )

		set( ENABLE_TESTS OFF )

	endif()

endif()
