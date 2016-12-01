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

CMAKE_FORCE_C_COMPILER       ( cc  Intel )
CMAKE_FORCE_CXX_COMPILER     ( CC  Intel )
CMAKE_FORCE_Fortran_COMPILER ( ftn Intel )

set( ECBUILD_FIND_MPI OFF )
set( ECBUILD_TRUST_FLAGS ON )

####################################################################
# OpenMP FLAGS
####################################################################

set( OMP_C_FLAGS             "-openmp -openmp-threadprivate=compat" )
set( OMP_CXX_FLAGS           "-openmp -openmp-threadprivate=compat" )
set( OMP_Fortran_FLAGS       "-openmp -openmp-threadprivate=compat" )

####################################################################
# COMMON FLAGS
####################################################################

# for diagnostics:
#  -diag-enable=vec -diag-file -Winline

set( ECBUILD_C_FLAGS       "-fp-speculation=strict -fp-model precise -traceback")
set( ECBUILD_CXX_FLAGS     "-fp-speculation=strict -fp-model precise -traceback" )
set( ECBUILD_Fortran_FLAGS "-fp-speculation=strict -fp-model source  -convert big_endian -assume byterecl -traceback -fpe0" )

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

set( ECBUILD_SHARED_LINKER_FLAGS "-Wl,--eh-frame-hdr" )
set( ECBUILD_MODULE_LINKER_FLAGS "-Wl,--eh-frame-hdr -Wl,-Map,loadmap" )
set( ECBUILD_EXE_LINKER_FLAGS    "-Wl,--eh-frame-hdr -Wl,-Map,loadmap -Wl,--as-needed" )

####################################################################
# LIBRARIES
####################################################################

# Don't search for LAPACK as it is provided by the cray-libsci module which is
# loaded by default
set( LAPACK_FOUND $ENV{CRAY_LIBSCI_PREFIX_DIR} )
