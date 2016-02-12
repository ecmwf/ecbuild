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
# LINK FLAGS
####################################################################

set( ECBUILD_C_LINK_FLAGS        "-Wl,-Map,load.map -Wl,--as-needed" )
set( ECBUILD_CXX_LINK_FLAGS      "-Wl,-Map,load.map -Wl,--as-needed" )
set( ECBUILD_Fortran_LINK_FLAGS  "-Wl,-Map,load.map -Wl,--as-needed" )
