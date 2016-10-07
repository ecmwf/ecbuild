####################################################################
# ARCHITECTURE
####################################################################
set( CMAKE_SIZEOF_VOID_P 8 )

# Disable relative rpaths as aprun does not respect it
set( ENABLE_RELATIVE_RPATHS OFF CACHE STRING "Disable relative rpaths" FORCE )

####################################################################
# COMPILER
####################################################################

include(CMakeForceCompiler)

CMAKE_FORCE_C_COMPILER       ( cc  Cray )
CMAKE_FORCE_CXX_COMPILER     ( CC  Cray )
CMAKE_FORCE_Fortran_COMPILER ( ftn Cray )

set( ECBUILD_FIND_MPI OFF )
set( ECBUILD_TRUST_FLAGS ON )

####################################################################
# MPI
####################################################################

set( MPIEXEC                 "aprun" )
set( MPIEXEC_NUMPROC_FLAG    "-n"    )
set( MPIEXEC_NUMTHREAD_FLAG  "-d"    )

####################################################################
# OpenMP FLAGS
####################################################################

set( OMP_C_FLAGS             "-homp" )
set( OMP_CXX_FLAGS           "-homp" )
set( OMP_Fortran_FLAGS       "-homp" )

set( OMPSTUBS_C_FLAGS        "-hnoomp" )
set( OMPSTUBS_CXX_FLAGS      "-hnoomp" )
set( OMPSTUBS_Fortran_FLAGS  "-hnoomp" )

####################################################################
# LINK FLAGS
####################################################################

set( ECBUILD_C_LINK_FLAGS        "-Wl,-Map,loadmap -Wl,--as-needed -Ktrap=fp" )
set( ECBUILD_CXX_LINK_FLAGS      "-Wl,-Map,loadmap -Wl,--as-needed -Ktrap=fp" )
set( ECBUILD_Fortran_LINK_FLAGS  "-Wl,-Map,loadmap -Wl,--as-needed -Ktrap=fp" )
set( ECBUILD_CXX_IMPLICIT_LINK_LIBRARIES "$ENV{CC_X86_64}/lib/x86-64/libcray-c++-rts.so" CACHE STRING "" )
