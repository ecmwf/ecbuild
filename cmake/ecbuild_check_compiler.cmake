# (C) Copyright 1996-2012 ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

############################################################################################
# try to get compiler version if cmake did not

if( NOT CMAKE_C_COMPILER_VERSION )

    set( EC_COMPILER_VERSION "?.?" )

    if( CMAKE_C_COMPILER_ID MATCHES "GNU" OR CMAKE_C_COMPILER_ID MATCHES "Intel" )
        exec_program( ${CMAKE_C_COMPILER}
                      ARGS ${CMAKE_C_COMPILER_ARG1} -dumpversion
                      OUTPUT_VARIABLE EC_COMPILER_VERSION )

        string(REGEX REPLACE "([0-9])\\.([0-9])(\\.([0-9]))?" "\\1.\\2"  EC_COMPILER_VERSION ${EC_COMPILER_VERSION} )
    endif()

    if( CMAKE_C_COMPILER_ID MATCHES "Clang" )
        exec_program( ${CMAKE_C_COMPILER}
                      ARGS ${CMAKE_C_COMPILER_ARG1} --version
                      OUTPUT_VARIABLE EC_COMPILER_VERSION )

        string(REGEX REPLACE ".*clang version ([0-9])\\.([0-9])(\\.([0-9]))?.*" "\\1.\\2" EC_COMPILER_VERSION ${EC_COMPILER_VERSION} )
    endif()

    if( CMAKE_C_COMPILER_ID MATCHES "SunPro" )
        exec_program( ${CMAKE_C_COMPILER}
                      ARGS ${CMAKE_C_COMPILER_ARG1} -V
                      OUTPUT_VARIABLE EC_COMPILER_VERSION )

        string(REGEX REPLACE ".*([0-9]+)\\.([0-9]+).*" "\\1.\\2" EC_COMPILER_VERSION ${EC_COMPILER_VERSION} )
    endif()

    if( CMAKE_C_COMPILER_ID MATCHES "XL" )
        exec_program( ${CMAKE_C_COMPILER}
                      ARGS ${CMAKE_C_COMPILER_ARG1} -qversion
                      OUTPUT_VARIABLE EC_COMPILER_VERSION )

        string(REGEX REPLACE ".*V([0-9]+)\\.([0-9]+).*" "\\1.\\2" EC_COMPILER_VERSION ${EC_COMPILER_VERSION} )

    endif()

    if( NOT EC_COMPILER_VERSION STREQUAL "?.?" )
        set(CMAKE_C_COMPILER_VERSION "${EC_COMPILER_VERSION}" )
    endif()

endif()

############################################################################################
# c compiler tests

check_c_source_compiles( 
      " typedef int foo_t;
        static inline foo_t static_foo(){return 0;}
        foo_t foo(){return 0;}
        int main(int argc, char *argv[]){return 0;}
      " EC_HAVE_C_INLINE )

############################################################################################
# c++ compiler tests

if( CMAKE_CXX_COMPILER_LOADED )

    # check for __FUNCTION__
	check_cxx_source_compiles( "#include <iostream>\nint main(int argc, char* argv[]) { std::cout << __FUNCTION__ << std::endl; }"
		EC_HAVE_FUNCTION_DEF )
    
    # check for c++ abi, usually present in GNU compilers
	check_cxx_source_compiles( "#include <cxxabi.h>\n int main() { char * type; int status; char * r = abi::__cxa_demangle(type, 0, 0, &status); }"
		EC_HAVE_CXXABI_H )
    
    # check for bool
	check_cxx_source_compiles( "int main() { bool aflag = true; }"
		EC_HAVE_CXX_BOOL )
    
    # check for sstream
	check_cxx_source_compiles( "#include <sstream>\nint main() { std::stringstream s; }"
		EC_HAVE_CXX_SSTREAM )
    
endif()

############################################################################################
# For 64 bit architectures enable position-independent code

if( EC_OS_BITS EQUAL "64" OR EC_OS_BITS GREATER "64" )

	if( CMAKE_COMPILER_IS_GNUCC )
		cmake_add_c_flags("-fPIC")
	endif()

	if( CMAKE_COMPILER_IS_GNUCXX )
		cmake_add_cxx_flags("-fPIC")
	endif()

	if( ${CMAKE_C_COMPILER_ID} STREQUAL "Cray" )
		cmake_add_c_flags("-hPIC")
	endif()

	if( ${CMAKE_CXX_COMPILER_ID} STREQUAL "Cray" )
		cmake_add_cxx_flags("-hPIC")
	endif()

endif()

############################################################################################
# enable warnings

if( CMAKE_COMPILER_IS_GNUCC )

    cmake_add_c_flags("-pipe") # use pipe for faster compilation

    if( ENABLE_WARNINGS )
        cmake_add_c_flags("-Wall")
        #    cmake_add_c_flags("-Wextra")
    endif()

endif()

if( CMAKE_COMPILER_IS_GNUCXX )

   cmake_add_cxx_flags("-pipe") # use pipe for faster compilation

    if( ENABLE_WARNINGS )
        cmake_add_cxx_flags("-Wall")
        #    cmake_add_cxx_flags("-Wextra")
    endif()

endif()

