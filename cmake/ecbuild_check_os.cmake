# (C) Copyright 1996-2012 ECMWF.
# 
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0. 
# In applying this licence, ECMWF does not waive the privileges and immunities 
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

############################################################################################
# check compiler version

set( EC_COMPILER_VERSION "?.?" )

if( CMAKE_CXX_COMPILER_ID MATCHES "GNU" OR CMAKE_CXX_COMPILER_ID MATCHES "Intel" )
    exec_program( ${CMAKE_CXX_COMPILER} 
                  ARGS ${CMAKE_CXX_COMPILER_ARG1} -dumpversion
                  OUTPUT_VARIABLE EC_COMPILER_VERSION )

    string(REGEX REPLACE "([0-9])\\.([0-9])(\\.([0-9]))?" "\\1.\\2"
                 EC_COMPILER_VERSION ${EC_COMPILER_VERSION} )
endif()

if( CMAKE_CXX_COMPILER_ID MATCHES "Clang" )
    exec_program( ${CMAKE_CXX_COMPILER} 
                  ARGS ${CMAKE_CXX_COMPILER_ARG1} --version
                  OUTPUT_VARIABLE EC_COMPILER_VERSION )

    string(REGEX REPLACE ".*([0-9])\\.([0-9])(\\.([0-9]))?.*" "\\1.\\2"
                 EC_COMPILER_VERSION ${EC_COMPILER_VERSION} )
endif()

if( CMAKE_CXX_COMPILER_ID MATCHES "SunPro" )
    exec_program( ${CMAKE_CXX_COMPILER} 
                  ARGS ${CMAKE_CXX_COMPILER_ARG1} -V
                  OUTPUT_VARIABLE EC_COMPILER_VERSION )

    string(REGEX REPLACE ".*([0-9]+)\\.([0-9]+).*" "\\1.\\2"
                 EC_COMPILER_VERSION ${EC_COMPILER_VERSION} )
endif()

if( CMAKE_CXX_COMPILER_ID MATCHES "XL" )
    exec_program( ${CMAKE_CXX_COMPILER} 
                  ARGS ${CMAKE_CXX_COMPILER_ARG1} -qversion
                  OUTPUT_VARIABLE EC_COMPILER_VERSION )
    
    string(REGEX REPLACE ".*V([0-9]+)\\.([0-9]+).*" "\\1.\\2"
                 EC_COMPILER_VERSION ${EC_COMPILER_VERSION} )

endif()


############################################################################################
# check architecture architecture

check_type_size("void *"       EC_SIZEOF_PTR )
check_type_size(char           EC_SIZEOF_CHAR)
check_type_size(short          EC_SIZEOF_SHORT)
check_type_size(int            EC_SIZEOF_INT)
check_type_size(long           EC_SIZEOF_LONG)
check_type_size("long long"    EC_SIZEOF_LONG_LONG)
check_type_size(float          EC_SIZEOF_FLOAT)
check_type_size(double         EC_SIZEOF_DOUBLE)
check_type_size(size_t         EC_SIZEOF_SIZE_T)
check_type_size(ssize_t        EC_SIZEOF_SSIZE_T)
check_type_size(off_t          EC_SIZEOF_OFF_T)

############################################################################################
# check endiness

test_big_endian( _BIG_ENDIAN )

if( _BIG_ENDIAN )
    set( EC_BIG_ENDIAN    1 )
else()
    set( EC_LITTLE_ENDIAN 1 )
    add_definitions( -DLITTLE_ENDIAN )
endif()

check_cxx_source_runs(
     "int compare(unsigned char* a,unsigned char* b) {
       while(*a != 0) if (*(b++)!=*(a++)) return 1;
       return 0;
     }
     int main(int argc,char** argv) {
       unsigned char dc[]={0x30,0x61,0xDE,0x80,0x93,0x67,0xCC,0xD9,0};
       double da=1.23456789e-75;
       unsigned char* ca;
     
       unsigned char fc[]={0x05,0x83,0x48,0x22,0};
       float fa=1.23456789e-35;
     
       if (sizeof(double)!=8) return 1;
     
       ca=(unsigned char*)&da;
       if (compare(dc,ca)) return 1;

       if (sizeof(float)!=4) return 1;

       ca=(unsigned char*)&fa;
       if (compare(fc,ca)) return 1;
     
       return 0;
     }" IEEE_BE )

if( "${IEEE_BE}" STREQUAL "" )
    set( IEEE_BE 0 CACHE INTERNAL "Test IEEE_BE")
endif()

check_cxx_source_runs(
     "int compare(unsigned char* a,unsigned char* b) {
       while(*a != 0) if (*(b++)!=*(a++)) return 1;
       return 0;
     }
     int main(int argc,char** argv) {
       unsigned char dc[]={0xD9,0xCC,0x67,0x93,0x80,0xDE,0x61,0x30,0};
       double da=1.23456789e-75;
       unsigned char* ca;
     
       unsigned char fc[]={0x22,0x48,0x83,0x05,0};
       float fa=1.23456789e-35;
     
       if (sizeof(double)!=8) return 1;
     
       ca=(unsigned char*)&da;
       if (compare(dc,ca)) return 1;

       if (sizeof(float)!=4) return 1;

       ca=(unsigned char*)&fa;
       if (compare(fc,ca)) return 1;
     
       return 0;
     }" IEEE_LE )

if( "${IEEE_BE}" STREQUAL "" )
    set( IEEE_LE 0 CACHE INTERNAL "Test IEEE_LE")
endif()


############################################################################################
# check operating system

math( EXPR EC_OS_BITS "${EC_SIZEOF_PTR} * 8")

if( NOT EC_OS_BITS EQUAL "32" AND NOT EC_OS_BITS EQUAL "64" )
    message( STATUS "OS system          [${CMAKE_SYSTEM}]" )
    message( FATAL_ERROR "mars only supported on 32 or 64 bit OS's" )
endif()

set( EC_OS_NAME "UNKNOWN" )
if( UNIX )

    if( APPLE AND ${CMAKE_SYSTEM_NAME} MATCHES "Darwin" ) # Mac OS X
        set( EC_OS_NAME "macosx" )
    endif()

    if( ${CMAKE_SYSTEM_NAME} MATCHES "Linux" ) # Linux
        set( EC_OS_NAME "linux" )
    endif()

    if( ${CMAKE_SYSTEM_NAME} MATCHES "AIX" )
    
        if( CMAKE_CXX_COMPILER_ID MATCHES "GNU" )
            set( CMAKE_SHARED_LINKER_FLAGS "-Xlinker -qbigtoc ${CMAKE_SHARED_LINKER_FLAGS}" )
        endif()

        set( EC_OS_NAME "aix" )

        if( CMAKE_COMPILER_IS_GNUCC )
            if( EC_OS_BITS EQUAL "64" )
                cmake_add_c_flags("-maix64")
            endif()
            if( EC_OS_BITS EQUAL "32" )
                cmake_add_c_flags("-maix32")
            endif()
        endif()

        if( CMAKE_COMPILER_IS_GNUCXX )
            if( EC_OS_BITS EQUAL "64" )
                cmake_add_cxx_flags("-maix64")
            endif()
            if( EC_OS_BITS EQUAL "32" )
                cmake_add_cxx_flags("-maix32")
            endif()
        endif()

        if( CMAKE_CXX_COMPILER_ID MATCHES "XL" )

            cmake_add_cxx_flags("-bmaxdata:0x40000000")
            cmake_add_cxx_flags("-qrtti")
            cmake_add_cxx_flags("-qfuncsect")
    
            if(EC_OS_BITS EQUAL "32" )
                cmake_add_c_flags("-q32")
                cmake_add_cxx_flags("-q32")
            endif()
            
             if(${CMAKE_BUILD_TYPE} MATCHES "Release" OR
                ${CMAKE_BUILD_TYPE} MATCHES "Production" )
                    cmake_add_c_flags("-qstrict")
                    cmake_add_cxx_flags("-qstrict")
                    cmake_add_c_flags("-qinline")
                    cmake_add_cxx_flags("-qinline")
             endif()
    
             if(${CMAKE_BUILD_TYPE} MATCHES "Debug")
                    cmake_add_c_flags("-qfullpath")
                    cmake_add_cxx_flags("-qfullpath")
                    cmake_add_c_flags("-qkeepparm")
                    cmake_add_cxx_flags("-qkeepparm")
    #                cmake_add_c_flags("-qwarn64")
    #                cmake_add_cxx_flags("-qwarn64")
             endif()

        endif()

    endif()

endif()

if( WIN32 )
    if( CYGWIN ) # cygwin under windows
        set( EC_OS_NAME "cygwin" )
    else()
        message( FATAL_ERROR "mars can only be built on Windows using Cygwin" )
    endif()
endif()

if( ${EC_OS_NAME} MATCHES "UNKNOWN" )
    message( FATAL_ERROR "mars cmake build system does not support operating system: [${CMAKE_SYSTEM_NAME}]" )
endif()

add_definitions( -D${EC_OS_NAME} )

############################################################################################
# enable warnings

if( CMAKE_COMPILER_IS_GNUCC )

    # use pipe for faster compilation
    cmake_add_c_flags("-pipe")
    cmake_add_cxx_flags("-pipe")

    if( ENABLE_WARNINGS )
        cmake_add_c_flags("-Wall")
        cmake_add_cxx_flags("-Wall")
    #    cmake_add_c_flags("-Wextra")
    #    cmake_add_cxx_flags("-Wextra")
    endif()

endif()

############################################################################################
# save final flags to cache

get_property( langs GLOBAL PROPERTY ENABLED_LANGUAGES )

foreach( lang ${langs} )
    set( EC_${lang}_FLAGS_ALL "${CMAKE_${lang}_FLAGS} ${CMAKE_${lang}_FLAGS_${EC_BUILD_TYPE}}" CACHE INTERNAL "full ${lang} compilation flags" )
endforeach()

