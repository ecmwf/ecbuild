# (C) Copyright 2011- ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

############################################################################################
# check size of pointer

# Re-check size of void pointer since for some compiler combinations this is not properly set
ecbuild_cache_check_type_size( "void*" CMAKE_SIZEOF_VOID_P  )

if( NOT CMAKE_C_COMPILER_LOADED AND ENABLE_OS_TESTS )

  enable_language( C )
  ecbuild_compiler_flags( C )

endif()

math( EXPR EC_OS_BITS "${CMAKE_SIZEOF_VOID_P} * 8" )

# we only support 32 and 64 bit operating systems
if( NOT EC_OS_BITS EQUAL "32" AND NOT EC_OS_BITS EQUAL "64" )
  ecbuild_critical( "operating system ${CMAKE_SYSTEM} ${EC_OS_BITS} bits -- ecbuild only supports 32 or 64 bit OS's" )
endif()

############################################################################################
# For 64 bit architectures enable PIC (position-independent code)

# Allow overriding the position independent code setting (ECBUILD-220)
if( DEFINED ECBUILD_POSITION_INDEPENDENT_CODE )
  set( CMAKE_POSITION_INDEPENDENT_CODE ${ECBUILD_POSITION_INDEPENDENT_CODE} )
elseif( ${EC_OS_BITS} EQUAL 64 )
  set( CMAKE_POSITION_INDEPENDENT_CODE ON )
endif()


############################################################################################
# check architecture

if( ENABLE_OS_TYPES_TEST )

  set( EC_SIZEOF_PTR ${CMAKE_SIZEOF_VOID_P} )
  ecbuild_cache_var( EC_SIZEOF_PTR )

  ecbuild_cache_check_type_size( char           EC_SIZEOF_CHAR        )
  ecbuild_cache_check_type_size( short          EC_SIZEOF_SHORT       )
  ecbuild_cache_check_type_size( int            EC_SIZEOF_INT         )
  ecbuild_cache_check_type_size( long           EC_SIZEOF_LONG        )
  ecbuild_cache_check_type_size( "long long"    EC_SIZEOF_LONG_LONG   )
  ecbuild_cache_check_type_size( float          EC_SIZEOF_FLOAT       )
  ecbuild_cache_check_type_size( double         EC_SIZEOF_DOUBLE      )
  ecbuild_cache_check_type_size( "long double"  EC_SIZEOF_LONG_DOUBLE )
  ecbuild_cache_check_type_size( size_t         EC_SIZEOF_SIZE_T      )
  ecbuild_cache_check_type_size( ssize_t        EC_SIZEOF_SSIZE_T     )
  ecbuild_cache_check_type_size( off_t          EC_SIZEOF_OFF_T       )

  ecbuild_debug( "sizeof void*       [${EC_SIZEOF_PTR}]" )
  ecbuild_debug( "sizeof char        [${EC_SIZEOF_CHAR}]" )
  ecbuild_debug( "sizeof short       [${EC_SIZEOF_SHORT}]" )
  ecbuild_debug( "sizeof int         [${EC_SIZEOF_INT}]" )
  ecbuild_debug( "sizeof long        [${EC_SIZEOF_LONG}]" )
  ecbuild_debug( "sizeof long long   [${EC_SIZEOF_LONG_LONG}]" )
  ecbuild_debug( "sizeof float       [${EC_SIZEOF_FLOAT}]" )
  ecbuild_debug( "sizeof double      [${EC_SIZEOF_DOUBLE}]" )
  ecbuild_debug( "sizeof long double [${EC_SIZEOF_LONG_DOUBLE}]" )
  ecbuild_debug( "sizeof size_t      [${EC_SIZEOF_SIZE_T}]" )
  ecbuild_debug( "sizeof ssize_t     [${EC_SIZEOF_SSIZE_T}]" )
  ecbuild_debug( "sizeof off_t       [${EC_SIZEOF_OFF_T}]" )

endif()

############################################################################################
# check for large file support

# ensure we use 64bit access to files even on 32bit os -- aka Large File Support
# by making off_t 64bit and stat behave as stat64

if( ENABLE_LARGE_FILE_SUPPORT )

  ecbuild_cache_check_type_size( off_t EC_SIZEOF_OFF_T )

  if( EC_SIZEOF_OFF_T LESS "8" )

    if( ${CMAKE_SYSTEM_NAME} MATCHES "Linux" OR ${CMAKE_SYSTEM_NAME} MATCHES "Darwin" )
      add_definitions( -D_FILE_OFFSET_BITS=64 )
    endif()

    if( ${CMAKE_SYSTEM_NAME} MATCHES "AIX" )
      add_definitions( -D_LARGE_FILES=64 )
    endif()

    get_directory_property( __compile_defs COMPILE_DEFINITIONS )

    if( __compile_defs )
      foreach( def ${__compile_defs} )
        list( APPEND CMAKE_REQUIRED_DEFINITIONS -D${def} )
      endforeach()
    endif()

  endif()

endif()

############################################################################################
# check endiness

if( ENABLE_OS_ENDINESS_TEST )

  if( NOT DEFINED EC_BIG_ENDIAN AND NOT DEFINED EC_LITTLE_ENDIAN )

    test_big_endian( _BIG_ENDIAN )

    if( _BIG_ENDIAN )
        set( EC_BIG_ENDIAN    1 )
        set( EC_LITTLE_ENDIAN 0 )
    else()
        set( EC_BIG_ENDIAN    0 )
        set( EC_LITTLE_ENDIAN 1 )
    endif()

  endif()

  ecbuild_cache_var( EC_BIG_ENDIAN )
  ecbuild_cache_var( EC_LITTLE_ENDIAN )

  if( NOT DEFINED IEEE_BE )
    check_c_source_runs(
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

  endif()

  ecbuild_cache_var( IEEE_BE )

  if( EC_BIG_ENDIAN AND NOT IEEE_BE )
    ecbuild_critical("Failed to sanity check on endiness: OS should be Big-Endian but compiled code runs differently -- to ignore this pass -DIEEE_BE=0 to CMake/ecBuild")
  endif()

  if( NOT DEFINED IEEE_LE )
    check_c_source_runs(
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

    if( "${IEEE_LE}" STREQUAL "" )
      set( IEEE_LE 0 CACHE INTERNAL "Test IEEE_LE")
    endif()
  endif()

  ecbuild_cache_var( IEEE_LE )

  if( EC_LITTLE_ENDIAN AND NOT IEEE_LE )
    ecbuild_critical("Failed to sanity check on endiness: OS should be Little-Endian but compiled code runs differently -- to ignore this pass -DIEEE_LE=0 to CMake/ecBuild")
  endif()

endif()

############################################################################################
# enable profiling via gprof

if( ENABLE_PROFILING )
  ecbuild_deprecate( "ENABLE_PROFILING is deprecated and ignored, use ENABLE_GPROF instead" )
endif()

if( ENABLE_GPROF )

  # User defined profiling flag takes precedence
  if( ECBUILD_GPROF_FLAG )

    ecbuild_debug( "Enabling profiling with user defined flag '${ECBUILD_GPROF_FLAG}'" )

  # -p  Generate extra code to write profile information suitable for the analysis program
  #     prof.  You must use this option when compiling the source files you want data about,
  #     and you must also use it when linking.
  #
  # -pg Generate extra code to write profile information suitable for the analysis program
  #     gprof.  You must use this option when compiling the source files you want data about,
  #     and you must also use it when linking.
  #
  # --coverage
  #      This option is used to compile and link code instrumented for coverage analysis.  The
  #      option is a synonym for -fprofile-arcs -ftest-coverage (when compiling) and -lgcov
  #      (when linking).  See the documentation for those options for more details.
  #
  #      *   Compile the source files with -fprofile-arcs plus optimization and code generation
  #          options.  For test coverage analysis, use the additional -ftest-coverage option.
  #          You do not need to profile every source file in a program.
  #
  #      *   Link your object files with -lgcov or -fprofile-arcs (the latter implies the
  #          former).
  #
  #      *   Run the program on a representative workload to generate the arc profile
  #          information.  This may be repeated any number of times.  You can run concurrent
  #          instances of your program, and provided that the file system supports locking, the
  #          data files will be correctly updated.  Also "fork" calls are detected and correctly
  #          handled (double counting will not happen).
  #
  #      *   For profile-directed optimizations, compile the source files again with the same
  #          optimization and code generation options plus -fbranch-probabilities.
  #
  #      *   For test coverage analysis, use gcov to produce human readable information from the
  #          .gcno and .gcda files.  Refer to the gcov documentation for further information.
  #
  #      With -fprofile-arcs, for each function of your program GCC creates a program flow
  #      graph, then finds a spanning tree for the graph.  Only arcs that are not on the
  #      spanning tree have to be instrumented: the compiler adds code to count the number of
  #      times that these arcs are executed.  When an arc is the only exit or only entrance to a
  #      block, the instrumentation code can be added to the block; otherwise, a new basic block
  #      must be created to hold the instrumentation code.
  elseif( CMAKE_C_COMPILER_ID MATCHES "GNU" )

    set( ECBUILD_GPROF_FLAG "-pg --coverage" )
    ecbuild_debug( "Enabling profiling with GNU flag '${ECBUILD_GPROF_FLAG}'" )

  # -p
  #
  #        Compiles and links for function profiling
  #               with gprof(1).
  #
  #        Architecture  Restrictions:  Not  available  on  Intel(R)   64   architecture
  #        targeting the
  #               Intel(R)  Xeon  Phi(TM) coprocessor x100 product family (formerly code
  #               name  Knights  Corner),  on  IA-32  architecture  targeting   Intel(R)
  #               Graphics Technology, or on Intel(R) 64 architecture targeting Intel(R)
  #               Graphics Technology
  #
  #        Arguments:
  #
  #        None
  #
  #        Default:
  #
  #        OFF               Files are compiled and linked without profiling.
  #
  #        Description:
  #
  #        This option compiles and links for function profiling with gprof(1).
  #
  #        When you specify this option, inlining is disabled. However, you can override
  #        this  by  specifying  pragma forceinline, declspec forceinline (Windows* OS),
  #        attribute always_inline (Linux* OS and OS X*), or a compiler option  such  as
  #        [Q]inline-forceinline.
  elseif( CMAKE_C_COMPILER_ID MATCHES "Intel" )

    set( ECBUILD_GPROF_FLAG "-p" )
    ecbuild_debug( "Enabling profiling with Intel flag '${ECBUILD_GPROF_FLAG}'" )

  # -Mprof[=option[,option,...]]
  #        Set performance profiling options.  Use of these options will cause the resulting
  #        executable to create a performance profile that can be viewed and analyzed with the
  #        PGPROF performance profiler.  In the descriptions below, PGI-style profiling implies
  #        compiler-generated source instrumentation.  MPICH-style profiling implies the use of
  #        instrumented wrappers for MPI library routines.  The -Mprof options are:
  #
  #        ccff
  #
  #        dwarf     Generate limited DWARF symbol information sufficient for most performance
  #                  profilers.
  #
  #        func      Perform PGI-style function level profiling.
  #
  #        hwcts     Generate a profile using event-based sampling of hardware counters via the
  #                  PAPI interface (linux86-64 only, PAPI must be installed).
  #
  #        lines     Perform PGI-style line level profiling.
  #
  #        hpmpi     (PGI CDK only) Perform MPICH-style profiling for the HP Implies
  #                  -Mmpi=hpmpi.
  #
  #        mpich1    (PGI CDK only) Perform MPICH-style profiling for MPICH-1.  Implies
  #                  -Mmpi=mpich1.  Use MPIDIR to point to the MPICH-1 libraries.  This flag is
  #                  no longer fully supported.
  #
  #        mpich2    (PGI CDK only) Perform MPICH-style profiling for MPICH-2.  Implies
  #                  -Mmpi=mpich2.  Use MPIDIR to point to the MPICH-1 libraries.  This flag is
  #                  no longer fully supported.
  #
  #        mvapich1  (PGI CDK only) Perform MPICH-style profiling for MVAPICH.  Implies
  #                  -Mmpi=mvapich1.  Use MPIDIR to point to the MPICH-1 libraries.  This flag
  #                  is no longer fully supported.
  #
  #        time      Generate a profile using time-based instruction-level statistical
  #                  sampling. This is equivalent to -pg, except that the profile is saved in a
  #                  file named pgprof.out instead of gmon.out.
  #
  #        On Linux systems that have OProfile installed, PGPROF supports collection of
  #        performance data without recompilation. Use of -Mprof=dwarf is useful for this mode
  #        of profiling.
  elseif( CMAKE_C_COMPILER_ID MATCHES "PGI" )

    set( ECBUILD_GPROF_FLAG "-Mprof=dwarf,time" )
    ecbuild_debug( "Enabling profiling with PGI flag '${ECBUILD_GPROF_FLAG}'" )

  # There is no equivalent to -pg for clang:
  # http://lists.llvm.org/pipermail/cfe-dev/2010-September/011255.html
  else()

    ecbuild_warn( "Profiling enabled but ecbuild doesn't know how to enable for this particular compiler ${CMAKE_C_COMPILER_ID}")

  endif()

  set( CMAKE_EXE_LINKER_FLAGS    "${CMAKE_EXE_LINKER_FLAGS} ${ECBUILD_GPROF_FLAG}" )
  set( CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} ${ECBUILD_GPROF_FLAG}" )
  set( CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} ${ECBUILD_GPROF_FLAG}" )

  set( _trust_flags ${ECBUILD_TRUST_FLAGS} )
  set( ECBUILD_TRUST_FLAGS ON )
  ecbuild_add_c_flags( "${ECBUILD_GPROF_FLAG}" )
  ecbuild_add_cxx_flags( "${ECBUILD_GPROF_FLAG}" )
  ecbuild_add_fortran_flags( "${ECBUILD_GPROF_FLAG}" )
  set( ECBUILD_TRUST_FLAGS ${_trust_flags} )
  unset( _trust_flags )

endif()

############################################################################################
# check operating system

set( EC_OS_NAME "UNKNOWN" )

### Unix's -- Proper operating systems

if( UNIX )

  ### APPLE ###

  if( APPLE AND ${CMAKE_SYSTEM_NAME} MATCHES "Darwin" )
    set( EC_OS_NAME "macosx" )
  endif()

  ### Linux ###

  if( ${CMAKE_SYSTEM_NAME} MATCHES "Linux" )

    set( EC_OS_NAME "linux" )

    # The following option allows enabling the new dtags linker option
    # (when set to OFF). ONLY SET TO OFF IF YOU KNOW WHAT YOU ARE DOING AND
    # NEVER WHEN BUILDING PRODUCTION SOFTWARE. YOU HAVE BEEN WARNED!
    option( ECBUILD_DISABLE_NEW_DTAGS "Set the linker flag --disable-new-dtags" ON )
    mark_as_advanced( ECBUILD_DISABLE_NEW_DTAGS )

    if( ECBUILD_DISABLE_NEW_DTAGS )
      # recent linkers default to --enable-new-dtags
      # which then adds both RPATH and RUNPATH to executables
      # thus invalidating RPATH setting, and making LD_LIBRARY_PATH take precedence
      # to be sure, use tool 'readelf -a <exe> | grep PATH' to see what paths are built-in
      # see:
      #  * http://blog.qt.digia.com/blog/2011/10/28/rpath-and-runpath
      #  * http://www.cmake.org/Wiki/CMake_RPATH_handling
      #  * man ld
      #  * http://blog.tremily.us/posts/rpath
      #  * http://fwarmerdam.blogspot.co.uk/2010/12/rpath-runpath-and-ldlibrarypath.html
      set(CMAKE_EXE_LINKER_FLAGS     "${CMAKE_EXE_LINKER_FLAGS}    -Wl,--disable-new-dtags")
      set(CMAKE_SHARED_LINKER_FLAGS  "${CMAKE_SHARED_LINKER_FLAGS} -Wl,--disable-new-dtags")
      set(CMAKE_MODULE_LINKER_FLAGS  "${CMAKE_MODULE_LINKER_FLAGS} -Wl,--disable-new-dtags")
    endif()

  endif()

  ### FreeBSD ###

  if( ${CMAKE_SYSTEM_NAME} MATCHES "FreeBSD" )
    set( EC_OS_NAME "freebsd" )
  endif()

  ### Solaris ###

  if( ${CMAKE_SYSTEM_NAME} MATCHES "SunOS" )
    set( EC_OS_NAME "solaris" )
  endif()

  ### AIX ###

  if( ${CMAKE_SYSTEM_NAME} MATCHES "AIX" )

    set( EC_OS_NAME "aix" )

    set( CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -bbigtoc" )

    if( CMAKE_C_COMPILER_ID MATCHES "GNU" )
      set( CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Xlinker" )
    endif()

    if( CMAKE_COMPILER_IS_GNUCC )
      if( EC_OS_BITS EQUAL "64" )
        ecbuild_add_c_flags("-maix64")
      endif()
      if( EC_OS_BITS EQUAL "32" )
        ecbuild_add_c_flags("-maix32")
      endif()
    endif()

    if( CMAKE_COMPILER_IS_GNUCXX )
      if( EC_OS_BITS EQUAL "64" )
        ecbuild_add_cxx_flags("-maix64")
      endif()
      if( EC_OS_BITS EQUAL "32" )
        ecbuild_add_cxx_flags("-maix32")
      endif()
    endif()

    if( CMAKE_C_COMPILER_ID MATCHES "XL" )

      ecbuild_add_c_flags("-qpic=large")
#            ecbuild_add_c_flags("-qweaksymbol")

      if(EC_OS_BITS EQUAL "32" )
        ecbuild_add_c_flags("-q32")
      endif()

      if(${CMAKE_BUILD_TYPE} MATCHES "Release" OR ${CMAKE_BUILD_TYPE} MATCHES "Production" )
          ecbuild_add_c_flags("-qstrict")
          ecbuild_add_c_flags("-qinline")
      endif()

      if(${CMAKE_BUILD_TYPE} MATCHES "Debug")
          ecbuild_add_c_flags("-qfullpath")
          ecbuild_add_c_flags("-qkeepparm")
      endif()

    endif()

    if( CMAKE_CXX_COMPILER_ID MATCHES "XL" )

      ecbuild_add_cxx_flags("-qpic=large")
      ecbuild_add_cxx_flags("-bmaxdata:0x40000000")
      ecbuild_add_cxx_flags("-qrtti")
      ecbuild_add_cxx_flags("-qfuncsect")

#           ecbuild_add_cxx_flags("-qweaksymbol")

      if(EC_OS_BITS EQUAL "32" )
        ecbuild_add_cxx_flags("-q32")
      endif()

      if(${CMAKE_BUILD_TYPE} MATCHES "Release" OR ${CMAKE_BUILD_TYPE} MATCHES "Production" )
          ecbuild_add_cxx_flags("-qstrict")
          ecbuild_add_cxx_flags("-qinline")
      endif()

      if(${CMAKE_BUILD_TYPE} MATCHES "Debug")
          ecbuild_add_cxx_flags("-qfullpath")
          ecbuild_add_cxx_flags("-qkeepparm")
      endif()

    endif()

    if( CMAKE_Fortran_COMPILER_ID MATCHES "XL" )

      ecbuild_add_fortran_flags("-qxflag=dealloc_cfptr")
      ecbuild_add_fortran_flags("-qextname")
      ecbuild_add_fortran_flags("-qdpc=e")
      ecbuild_add_fortran_flags("-bmaxdata:0x40000000")
      ecbuild_add_fortran_flags("-bloadmap:loadmap -bmap:loadmap")

      if(EC_OS_BITS EQUAL "32" )
        ecbuild_add_fortran_flags("-q32")
      endif()
    endif()

  endif()

endif()

### Cygwin

if( ${CMAKE_SYSTEM_NAME} MATCHES "CYGWIN" )

  set( EC_OS_NAME "cygwin" )
  ecbuild_warn( "Building on Cygwin should work but is untested" )

endif()

### final warning / error

if( ${EC_OS_NAME} MATCHES "UNKNOWN" )

  if( DISABLE_OS_CHECK )
    ecbuild_warn( "ecBuild is untested for this operating system: [${CMAKE_SYSTEM_NAME}]"
                  " -- DISABLE_OS_CHECK is ON so proceeding at your own risk ..." )
  else()
    ecbuild_critical( "ecBuild is untested for this operating system: [${CMAKE_SYSTEM_NAME}]"
                      " -- refusing to continue. Disable this check with -DDISABLE_OS_CHECK=ON" )
  endif()

endif()
