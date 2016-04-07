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
# MPI
####################################################################

set( MPIEXEC                 "aprun" )
set( MPIEXEC_NUMPROC_FLAG    "-n"    )

####################################################################
# OpenMP FLAGS
####################################################################

set( OMP_C_FLAGS             "-qopenmp -qopenmp-threadprivate=compat -qopenmp-report=2 -qopt-report-phase=vec,openmp" )
set( OMP_CXX_FLAGS           "-qopenmp -qopenmp-threadprivate=compat -qopenmp-report=2 -qopt-report-phase=vec,openmp" )
set( OMP_Fortran_FLAGS       " -openmp  -openmp-threadprivate=compat  -openmp-report=2  -opt-report-phase=vec,openmp" ) # -[q] is missing on purpose, ifort does not take -q as flag

set( OMP_NUMTHREAD_FLAG      "-d" )

####################################################################
# COMMON FLAGS
####################################################################

# for diagnostics:
#  -diag-enable=vec -diag-file -Winline

set( ECBUILD_C_FLAGS       "-fp-speculation=strict -fp-model precise -traceback")
set( ECBUILD_CXX_FLAGS     "-fp-speculation=strict -fp-model precise -traceback" )
set( ECBUILD_Fortran_FLAGS "-fp-speculation=strict -fp-model precise -convert big_endian -assume byterecl -traceback -fpe0" )

####################################################################
# BIT REPRODUCIBLE FLAGS
####################################################################

set( ECBUILD_C_FLAGS_BIT        "-O2 -xAVX -finline-function -finline-limit=500" )
set( ECBUILD_CXX_FLAGS_BIT      "-O2 -xAVX -finline-function -finline-limit=500" )
set( ECBUILD_Fortran_FLAGS_BIT  "-O2 -xAVX -finline-function -finline-limit=500 -align array64byte" )

####################################################################
# DEBUG FLAGS
####################################################################

set( ECBUILD_C_FLAGS_DEBUG        "-O0 -g -traceback -fp-trap=common" )
set( ECBUILD_CXX_FLAGS_DEBUG      "-O0 -g -traceback -fp-trap=common" )
# -check all implies -check bounds
set( ECBUILD_Fortran_FLAGS_DEBUG  "-O0 -g -traceback -warn all -heap-arrays -fpe-all=0 -fpe:0 -check all" )

####################################################################
# LINK FLAGS
####################################################################

set( ECBUILD_C_LINK_FLAGS        "-Wl,-Map,load.map -Wl,--as-needed" )
set( ECBUILD_CXX_LINK_FLAGS      "-Wl,-Map,load.map -Wl,--as-needed" )
set( ECBUILD_Fortran_LINK_FLAGS  "-Wl,-Map,load.map -Wl,--as-needed" )
