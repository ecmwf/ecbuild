####################################################################
# COMPILER
####################################################################

include(CMakeForceCompiler)

CMAKE_FORCE_C_COMPILER       ( cc  Intel )
CMAKE_FORCE_CXX_COMPILER     ( CC  Intel )
CMAKE_FORCE_Fortran_COMPILER ( ftn Intel )

set( ECBUILD_FIND_MPI OFF )
set( ECBUILD_TRUST_FLAGS ON )

####################################################################
# FLAGS COMMON TO ALL BUILD TYPES
####################################################################

set( OMP_C_FLAGS             "-fomp" )
set( OMP_CXX_FLAGS           "-fomp" )
set( OMP_Fortran_FLAGS       "-fomp" )

set( CMAKE_C_FLAGS_INIT       "" )
set( CMAKE_CXX_FLAGS_INIT     "" )
set( CMAKE_Fortran_FLAGS_INIT "" )

####################################################################
# RELEASE FLAGS
####################################################################

#set( ECBUILD_C_FLAGS_RELEASE       "-O3 -hfp3 -hscalar3 -hvector3 -DNDEBUG" )
#set( ECBUILD_CXX_FLAGS_RELEASE     "-O3 -hfp3 -hscalar3 -hvector3 -DNDEBUG" )
#set( ECBUILD_Fortran_FLAGS_RELEASE "-O3 -hfp3 -hscalar3 -hvector3 -DNDEBUG" )

####################################################################
# BIT REPRODUCIBLE FLAGS
####################################################################

set( ECBUILD_C_FLAGS_BIT        "-O1 -G2 -hflex_mp=conservative -hadd_paren -hfp1 -DNDEBUG" )
set( ECBUILD_CXX_FLAGS_BIT      "-O1 -G2 -hflex_mp=conservative -hadd_paren -hfp1 -DNDEBUG" )
set( ECBUILD_Fortran_FLAGS_BIT  "-O1 -G2 -hflex_mp=conservative -hadd_paren -hfp1 -DNDEBUG" )

####################################################################
# RELWITHDEBINFO FLAGS
####################################################################

#set( ECBUILD_C_FLAGS_RELWITHDEBINFO        "-O2 -hfp1 -Gfast -DNDEBUG" )
#set( ECBUILD_CXX_FLAGS_RELWITHDEBINFO      "-O2 -hfp1 -Gfast -DNDEBUG" )
#set( ECBUILD_Fortran_FLAGS_RELWITHDEBINFO  "-O2 -hfp1 -Gfast -DNDEBUG" )

####################################################################
# DEBUG FLAGS
####################################################################

#set( ECBUILD_C_FLAGS_DEBUG        "-O0 -G0" )
#set( ECBUILD_CXX_FLAGS_DEBUG      "-O0 -G0" )
#set( ECBUILD_Fortran_FLAGS_DEBUG  "-O0 -G0" )

####################################################################
# PRODUCTION FLAGS
####################################################################

#set( ECBUILD_C_FLAGS_PRODUCTION        "-O2 -hfp1 -G2" )
#set( ECBUILD_CXX_FLAGS_PRODUCTION      "-O2 -hfp1 -G2" )
#set( ECBUILD_Fortran_FLAGS_PRODUCTION  "-O2 -hfp1 -G2" )

####################################################################
# LINK FLAGS
####################################################################

#set( ECBUILD_C_LINK_FLAGS        "-Wl,-Map,loadmap -Wl,--as-needed -Ktrap=fp" )
#set( ECBUILD_CXX_LINK_FLAGS      "-Wl,-Map,loadmap -Wl,--as-needed -Ktrap=fp" )
#set( ECBUILD_Fortran_LINK_FLAGS  "-Wl,-Map,loadmap -Wl,--as-needed -Ktrap=fp" )

