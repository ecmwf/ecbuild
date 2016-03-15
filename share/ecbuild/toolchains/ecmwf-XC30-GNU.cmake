####################################################################
# ARCHITECTURE
####################################################################
set( CMAKE_SIZEOF_VOID_P 8 )

####################################################################
# COMPILER
####################################################################

include(CMakeForceCompiler)

CMAKE_FORCE_C_COMPILER       ( cc  GNU )
CMAKE_FORCE_CXX_COMPILER     ( CC  GNU )
CMAKE_FORCE_Fortran_COMPILER ( ftn GNU )

set( ECBUILD_FIND_MPI OFF )
set( ECBUILD_TRUST_FLAGS ON )

####################################################################
# OpenMP FLAGS
####################################################################

set( OMP_C_FLAGS             "-fopenmp" )
set( OMP_CXX_FLAGS           "-fopenmp" )
set( OMP_Fortran_FLAGS       "-fopenmp" )

####################################################################
# DEBUG FLAGS
####################################################################

set( ECBUILD_C_FLAGS_DEBUG        "-O0 -g -ftrapv" )
set( ECBUILD_CXX_FLAGS_DEBUG      "-O0 -g -ftrapv" )
set( ECBUILD_Fortran_FLAGS_DEBUG  "-ffree-line-length-none -O0 -g -fcheck=bounds -fbacktrace -finit-real=snan -ffpe-trap=invalid,zero,overflow" )

####################################################################
# LINK FLAGS
####################################################################

set( ECBUILD_C_LINK_FLAGS        "-Wl,-Map,load.map -Wl,--as-needed" )
set( ECBUILD_CXX_LINK_FLAGS      "-Wl,-Map,load.map -Wl,--as-needed" )
set( ECBUILD_Fortran_LINK_FLAGS  "-Wl,-Map,load.map -Wl,--as-needed" )
