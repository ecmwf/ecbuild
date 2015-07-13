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
# FLAGS COMMON TO ALL BUILD TYPES
####################################################################

set( OMP_C_FLAGS             "-fopenmp" )
set( OMP_CXX_FLAGS           "-fopenmp" )
set( OMP_Fortran_FLAGS       "-fopenmp" )

set( CMAKE_C_FLAGS       "" )
set( CMAKE_CXX_FLAGS     "" )
set( CMAKE_Fortran_FLAGS "" )

####################################################################
# RELEASE FLAGS
####################################################################

#set( ECBUILD_C_FLAGS_RELEASE       "-O3 -hfp3 -hscalar3 -hvector3 -DNDEBUG" )
#set( ECBUILD_CXX_FLAGS_RELEASE     "-O3 -hfp3 -hscalar3 -hvector3 -DNDEBUG" )
#set( ECBUILD_Fortran_FLAGS_RELEASE "-O3 -hfp3 -hscalar3 -hvector3 -DNDEBUG" )

####################################################################
# BIT REPRODUCIBLE FLAGS
####################################################################

set( ECBUILD_C_FLAGS_BIT        "-g -O2 -m64 -march=native -DNDEBUG" )
set( ECBUILD_CXX_FLAGS_BIT      "-g -O2 -m64 -march=native -DNDEBUG" )
set( ECBUILD_Fortran_FLAGS_BIT  "-g -O2 -m64 -march=native -DNDEBUG -fno-range-check -ffree-line-length-300 -fconvert=big-endian" )

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

set( ECBUILD_C_LINK_FLAGS        "-Wl,-Map,load.map -Wl,--as-needed" )
set( ECBUILD_CXX_LINK_FLAGS      "-Wl,-Map,load.map -Wl,--as-needed" )
set( ECBUILD_Fortran_LINK_FLAGS  "-Wl,-Map,load.map -Wl,--as-needed" )

