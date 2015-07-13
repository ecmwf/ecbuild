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

set( OMP_C_FLAGS             "-qopenmp -qopenmp-threadprivate=compat -qopenmp-report=2 -qopt-report-phase=vec,openmp" )
set( OMP_CXX_FLAGS           "-qopenmp -qopenmp-threadprivate=compat -qopenmp-report=2 -qopt-report-phase=vec,openmp" )
set( OMP_Fortran_FLAGS       " -openmp  -openmp-threadprivate=compat  -openmp-report=2  -opt-report-phase=vec,openmp" ) # -[q] is missing on purpose, ifort does not take -q as flag

# for diagnostics:
#  -diag-enable=vec -diag-file -Winline

set( CMAKE_C_FLAGS       "-fp-speculation=strict -fp-model=precise -traceback" CACHE STRING "" FORCE )
set( CMAKE_CXX_FLAGS     "-fp-speculation=strict -fp-model=precise -traceback" CACHE STRING "" FORCE )
set( CMAKE_Fortran_FLAGS "-fp-speculation=strict -fp-model=precise -convert big_endian -assume byterecl -traceback -fpe0" CACHE STRING "" FORCE )

####################################################################
# RELEASE FLAGS
####################################################################

#set( ECBUILD_C_FLAGS_RELEASE       "not implemented" )
#set( ECBUILD_CXX_FLAGS_RELEASE     "not implemented" )
#set( ECBUILD_Fortran_FLAGS_RELEASE "not implemented" )

####################################################################
# BIT REPRODUCIBLE FLAGS
####################################################################

set( ECBUILD_C_FLAGS_BIT        "-O2 -xAVX -finline-function -finline-limit=500" )
set( ECBUILD_CXX_FLAGS_BIT      "-O2 -xAVX -finline-function -finline-limit=500" )
set( ECBUILD_Fortran_FLAGS_BIT  "-O2 -xAVX -finline-function -finline-limit=500 -align array64byte" )

####################################################################
# RELWITHDEBINFO FLAGS
####################################################################

#set( ECBUILD_C_FLAGS_RELWITHDEBINFO        "not implemented" )
#set( ECBUILD_CXX_FLAGS_RELWITHDEBINFO      "not implemented" )
#set( ECBUILD_Fortran_FLAGS_RELWITHDEBINFO  "not implemented" )

####################################################################
# DEBUG FLAGS
####################################################################

set( ECBUILD_C_FLAGS_DEBUG        "-g -O0" )
set( ECBUILD_CXX_FLAGS_DEBUG      "-g -O0" )
set( ECBUILD_Fortran_FLAGS_DEBUG  "-g -O0" ) # ??? -align array64byte

####################################################################
# PRODUCTION FLAGS
####################################################################

#set( ECBUILD_C_FLAGS_PRODUCTION        "not implemented" )
#set( ECBUILD_CXX_FLAGS_PRODUCTION      "not implemented" )
#set( ECBUILD_Fortran_FLAGS_PRODUCTION  "not implemented" )

####################################################################
# LINK FLAGS
####################################################################

set( ECBUILD_C_LINK_FLAGS        "-Wl,-Map,load.map -Wl,--as-needed" )
set( ECBUILD_CXX_LINK_FLAGS      "-Wl,-Map,load.map -Wl,--as-needed" )
set( ECBUILD_Fortran_LINK_FLAGS  "-Wl,-Map,load.map -Wl,--as-needed" )

