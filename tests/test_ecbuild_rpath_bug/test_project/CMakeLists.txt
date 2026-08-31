cmake_minimum_required(VERSION 3.12)

find_package( ecbuild REQUIRED )
project( test_ecbuild_rpath_bug VERSION 0.1.0 LANGUAGES C ) 

# ---------------------------------------------------------------------------
# Mimic the Intel environment: LD_RUN_PATH contains .../lib/release BEFORE
# .../lib.  This is the order produced by Intel oneAPI module files.
# ---------------------------------------------------------------------------

set(ENV{LD_RUN_PATH}
    "/opt/softs/gcc/9.2.0/lib64:\
/opt/softs/gcc/9.2.0/lib:\
/opt/softs/intel/oneapi/2023.2/mpi/2021.10.0/libfabric/lib:\
/opt/softs/intel/oneapi/2023.2/mpi/2021.10.0/lib/release:\
/opt/softs/intel/oneapi/2023.2/mpi/2021.10.0/lib:\
/opt/softs/intel/oneapi/2023.2/mkl/2023.2.0/lib/intel64:\
/opt/softs/intel/oneapi/2023.2/compiler/2023.2.0/linux/lib:\
/opt/softs/intel/oneapi/2023.2/compiler/2023.2.0/linux/lib/x64")

message("LD_RUN_PATH = $ENV{LD_RUN_PATH}")

ecbuild_linker_flags()

message("CMAKE_SHARED_LINKER_FLAGS = ${CMAKE_SHARED_LINKER_FLAGS}")

# Check whether the libmpifort directory survived.
if(CMAKE_SHARED_LINKER_FLAGS MATCHES "/opt/softs/intel/oneapi/2023.2/mpi/2021.10.0/lib( |$)")
    message(STATUS ".../mpi/2021.10.0/lib is present in rpath")
else()
    message(FATAL_ERROR "BUG REPRODUCED: .../mpi/2021.10.0/lib is missing from rpath")
endif()

# Also show the gcc/lib vs gcc/lib64 case.
if(CMAKE_SHARED_LINKER_FLAGS MATCHES "/opt/softs/gcc/9.2.0/lib( |$)")
    message(STATUS ".../gcc/9.2.0/lib is present in rpath")
else()
    message(FATAL_ERROR "BUG REPRODUCED: .../gcc/9.2.0/lib is missing from rpath")
endif()

