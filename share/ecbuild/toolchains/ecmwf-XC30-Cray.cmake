####################################################################
# COMPILER
####################################################################

include(CMakeForceCompiler)

CMAKE_FORCE_C_COMPILER       ( cc  Cray )
CMAKE_FORCE_CXX_COMPILER     ( CC  Cray )
CMAKE_FORCE_Fortran_COMPILER ( ftn Cray )

link_libraries("$ENV{CC_X86_64}/lib/x86-64/libcray-c++-rts.so")
link_libraries("-lmpichf90_cray")
link_libraries("-lmpichcxx_cray")

set( ECBUILD_FIND_MPI OFF )
set( ECBUILD_TRUST_FLAGS ON )

####################################################################
# FLAGS COMMON TO ALL BUILD TYPES
####################################################################

set( _common_C_FLAGS       "-lhugetlbfs" )
set( _common_CXX_FLAGS     "-lhugetlbfs" )
set( _common_Fortran_FLAGS "-lhugetlbfs -emf -rmoid" )

set( OMP_C_FLAGS             "-homp" )
set( OMP_CXX_FLAGS           "-homp" )
set( OMP_Fortran_FLAGS       "-homp" )

set( OMPSTUBS_C_FLAGS        "-hnoomp" )
set( OMPSTUBS_CXX_FLAGS      "-hnoomp" )
set( OMPSTUBS_Fortran_FLAGS  "-hnoomp" )

####################################################################
# BIT REPRODUCIBLE FLAGS
####################################################################

set( CMAKE_C_FLAGS_BIT        "-O2 -hflex_mp=conservative -hadd_paren -hfp1 ${_common_C_FLAGS}" )
set( CMAKE_CXX_FLAGS_BIT      "-O2 -hflex_mp=conservative -hadd_paren -hfp1 ${_common_CXX_FLAGS}" )
set( CMAKE_Fortran_FLAGS_BIT  "-O2 -hflex_mp=conservative -hadd_paren -hfp1 ${_common_Fortran_FLAGS}" )

####################################################################
# RELEASE FLAGS
####################################################################

set( CMAKE_C_FLAGS_RELEASE       "-O3 -hfp3 -hscalar3 -hvector3 ${_common_C_FLAGS}" )
set( CMAKE_CXX_FLAGS_RELEASE     "-O3 -hfp3 -hscalar3 -hvector3 ${_common_CXX_FLAGS}" )
set( CMAKE_Fortran_FLAGS_RELEASE "-O3 -hfp3 -hscalar3 -hvector3 ${_common_Fortran_FLAGS}" )

####################################################################
# DEBUG FLAGS
####################################################################

set( CMAKE_C_FLAGS_DEBUG        "-O0 -Gfast -Ktrap=fp ${_common_C_FLAGS}" )
set( CMAKE_CXX_FLAGS_DEBUG      "-O0 -Gfast -Ktrap=fp ${_common_CXX_FLAGS}" )
set( CMAKE_Fortran_FLAGS_DEBUG  "-O0 -Gfast -Ktrap=fp ${_common_Fortran_FLAGS}" )

####################################################################
# RELWITHDEBINFO FLAGS
####################################################################

set( CMAKE_C_FLAGS_RELWITHDEBINFO        "-hfp1 -G2 ${_common_C_FLAGS}" )
set( CMAKE_CXX_FLAGS_RELWITHDEBINFO      "-hfp1 -G2 ${_common_CXX_FLAGS}" )
set( CMAKE_Fortran_FLAGS_RELWITHDEBINFO  "-hfp1 -G2 ${_common_Fortran_FLAGS}" )

####################################################################
# LINK FLAGS
####################################################################

set( CMAKE_C_LINK_FLAGS        "-Wl,-Map,loadmap -Wl,--as-needed" )
set( CMAKE_CXX_LINK_FLAGS      "-Wl,-Map,loadmap -Wl,--as-needed" )
set( CMAKE_Fortran_LINK_FLAGS  "-Wl,-Map,loadmap -Wl,--as-needed" )
