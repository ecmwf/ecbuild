cmake_minimum_required(VERSION 3.16)

find_package(ecbuild HINTS ${CMAKE_CURRENT_SOURCE_DIR}/../.. )

project( fortran_compile_options VERSION 0.0.0 LANGUAGES Fortran )


#######################################################################################################
### Compilation without affecting this scope, using target_compile_options

if(CMAKE_Fortran_COMPILER_ID STREQUAL "GNU")
  set(ECBUILD_Fortran_COMPILE_OPTIONS_REAL4)
  set(ECBUILD_Fortran_COMPILE_OPTIONS_REAL8 -fdefault-real-8 -fdefault-double-8)
elseif(CMAKE_Fortran_COMPILER_ID STREQUAL "NVHPC")
  set(ECBUILD_Fortran_COMPILE_OPTIONS_REAL4 -r4)
  set(ECBUILD_Fortran_COMPILE_OPTIONS_REAL8 -r8)
elseif(CMAKE_Fortran_COMPILER_ID MATCHES "Intel")
  set(ECBUILD_Fortran_COMPILE_OPTIONS_REAL4)
  set(ECBUILD_Fortran_COMPILE_OPTIONS_REAL8 -r8)
endif()

# Compile program in single precision
ecbuild_add_executable(TARGET main_r4 SOURCES main.F90)
target_compile_options(main_r4 PUBLIC $<$<COMPILE_LANGUAGE:Fortran>:${ECBUILD_Fortran_COMPILE_OPTIONS_REAL4}>)

# Compile program in double precision
ecbuild_add_executable(TARGET main_r8 SOURCES main.F90)
target_compile_options(main_r8 PUBLIC $<$<COMPILE_LANGUAGE:Fortran>:${ECBUILD_Fortran_COMPILE_OPTIONS_REAL8}>)

#######################################################################################################
### Compilation affecting this scope. Warning, also targets above in this scope are affected!

# We can add flags as a single argument with semi-colon separated options as given by list
ecbuild_add_fortran_flags( -Dfoo;-Dbar )

# We can add flags as a expanded list
ecbuild_add_fortran_flags( -Dbas -Dbaz )

# Test that we can add an empty variable
set( empty )
ecbuild_add_fortran_flags( ${empty} )

ecbuild_add_executable(TARGET main SOURCES main.F90)

