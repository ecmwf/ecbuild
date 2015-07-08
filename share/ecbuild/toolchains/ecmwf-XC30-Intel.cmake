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

set( OMP_C_FLAGS             "-qopenmp -qopenmp-threadprivate=compat -qopenmp-report=2" )
set( OMP_CXX_FLAGS           "-qopenmp -qopenmp-threadprivate=compat -qopenmp-report=2" )
set( OMP_Fortran_FLAGS       "-openmp -openmp-threadprivate=compat -openmp-report=2" )

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

set( ECBUILD_C_FLAGS_BIT        "-traceback -fpic -fp-model source -O2 -xAVX -finline-function -finline-limit=500 -Winline -diag-enable=vec -diag-file" )
set( ECBUILD_CXX_FLAGS_BIT      "-traceback -fpic -fp-model source -O2 -xAVX -finline-function -finline-limit=500 -Winline -diag-enable=vec -diag-file" )
set( ECBUILD_Fortran_FLAGS_BIT  "-fpe0 -convert big_endian -assume byterecl -align array64byte -traceback -fpic -fp-model source -O2 -xAVX -finline-function -finline-limit=500 -Winline -diag-enable=vec -diag-file" )

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

