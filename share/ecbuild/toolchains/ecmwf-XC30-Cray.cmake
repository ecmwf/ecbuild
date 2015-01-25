####################################################################
# COMPILER
####################################################################

include(CMakeForceCompiler)

CMAKE_FORCE_C_COMPILER       ( cc  Cray )
CMAKE_FORCE_CXX_COMPILER     ( CC  Cray )
CMAKE_FORCE_Fortran_COMPILER ( ftn Cray )

####################################################################
# FLAGS COMMON TO ALL BUILD TYPES
####################################################################

set( CMAKE_C_FLAGS       "-lhugetlbfs" )
set( CMAKE_CXX_FLAGS     "-lhugetlbfs" )
set( CMAKE_Fortran_FLAGS "-lhugetlbfs -emf -rmoid" )

####################################################################
# BIT REPRODUCIBLE FLAGS
####################################################################

set( CMAKE_C_FLAGS_BIT        "-O2 -hflex_mp=conservative -hadd_paren -hfp1" )
set( CMAKE_CXX_FLAGS_BIT      "-O2 -hflex_mp=conservative -hadd_paren -hfp1" )
set( CMAKE_Fortran_FLAGS_BIT  "-O2 -hflex_mp=conservative -hadd_paren -hfp1" )

####################################################################
# RELEASE FLAGS
####################################################################

set( CMAKE_C_FLAGS_RELEASE       "-O3 -hfp3 -hscalar3 -hvector3 -hPIC" )
set( CMAKE_CXX_FLAGS_RELEASE     "-O3 -hfp3 -hscalar3 -hvector3 -hPIC" )
set( CMAKE_Fortran_FLAGS_RELEASE "-O3 -hfp3 -hscalar3 -hvector3 -hPIC" )

####################################################################
# DEBUG FLAGS
####################################################################

set( CMAKE_C_FLAGS_DEBUG        "-O0 -Gfast -Ktrap=fp" )
set( CMAKE_CXX_FLAGS_DEBUG      "-O0 -Gfast -Ktrap=fp" )
set( CMAKE_Fortran_FLAGS_DEBUG  "-O0 -Gfast -Ktrap=fp" )

####################################################################
# LINK FLAGS
####################################################################

set( CMAKE_C_LINK_FLAGS        "-Wl,-Map,loadmap" )
set( CMAKE_CXX_LINK_FLAGS      "-Wl,-Map,loadmap" )
set( CMAKE_Fortran_LINK_FLAGS  "-Wl,-Map,loadmap" )

####################################################################
# Add "-Wl,-Bdynamic" at very end of linker commands
####################################################################

set( CMAKE_C_LINK_EXECUTABLE
  "<CMAKE_C_COMPILER> <FLAGS> <CMAKE_C_LINK_FLAGS> <LINK_FLAGS> <OBJECTS>  -o <TARGET> <LINK_LIBRARIES> -Wl,-Bdynamic" )
set( CMAKE_CXX_LINK_EXECUTABLE
  "<CMAKE_CXX_COMPILER> <FLAGS> <CMAKE_CXX_LINK_FLAGS> <LINK_FLAGS> <OBJECTS>  -o <TARGET> <LINK_LIBRARIES> -Wl,-Bdynamic" )
set(CMAKE_Fortran_LINK_EXECUTABLE
  "<CMAKE_Fortran_COMPILER> <CMAKE_Fortran_LINK_FLAGS> <LINK_FLAGS> <FLAGS> <OBJECTS>  -o <TARGET> <LINK_LIBRARIES> -Wl,-Bdynamic" )
  
###################################################################
# FEATURES SETUP
###################################################################

set( ENABLE_EIGEN OFF )

###################################################################
