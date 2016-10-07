if(CMAKE_Fortran_COMPILER_ID MATCHES "Cray")

  set(FOO_Fortran_FLAGS "-ram -emf -hadd_paren") # common flags for all build types
  set(FOO_Fortran_FLAGS_RELEASE "-hflex_mp=conservative -Othread1 -hfp1")
  set(FOO_Fortran_FLAGS_RELWITHDEBINFO "-G2 ${FOO_Fortran_FLAGS_RELEASE}")
  set(FOO_Fortran_FLAGS_DEBUG "-G0 -hflex_mp=conservative -hfp0")

  set(FOO_C_FLAGS_RELEASE "-O0 -fPIC")
  set(FOO_C_FLAGS_RELWITHDEBINFO "-g -O0 -fPIC")
  set(FOO_C_FLAGS_DEBUG "-g -O0 -fPIC")

  set_source_files_properties(foo_contiguous.f90 PROPERTIES COMPILE_FLAGS "-hcontiguous")

  set_source_files_properties(foo_intolerant.f90
    PROPERTIES OVERRIDE_COMPILE_FLAGS_RELEASE "${FOO_Fortran_FLAGS} -hflex_mp=intolerant -hfp1"
               OVERRIDE_COMPILE_FLAGS_RELWITHDEBINFO "-G2 ${FOO_Fortran_FLAGS} -hflex_mp=intolerant -hfp1"
               OVERRIDE_COMPILE_FLAGS_DEBUG "-G0 ${FOO_Fortran_FLAGS} -hflex_mp=intolerant -hfp0")

  if($ENV{CRAY_FTN_VERSION} VERSION_EQUAL 8.4.1) # cdt/15.11

    set_source_files_properties(foo_ivybridge.f90 PROPERTIES COMPILE_FLAGS "-hcpu=ivybridge")

    string(TOUPPER ${CMAKE_BUILD_TYPE} btype)
    string(REGEX REPLACE "-g|-G[0-2]|-Gfast" "" flags "${FOO_Fortran_FLAGS_${btype}}")
    set_source_files_properties(foo_no_debug_symbols.f90 PROPERTIES OVERRIDE_COMPILE_FLAGS "${flags}")
    
  endif()

elseif(CMAKE_Fortran_COMPILER_ID MATCHES "GNU")

  # ...

elseif(CMAKE_Fortran_COMPILER_ID MATCHES "Intel")

  # ...

endif()
