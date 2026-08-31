cmake_minimum_required(VERSION 3.12)
# project() is not needed for this script-mode test

# ---------------------------------------------------------------------------
# Reproduce the ecbuild macros exactly as found in
# source/ecbuild/cmake/ecbuild_compiler_flags.cmake
# and source/ecbuild/cmake/ecbuild_regex_escape.cmake
# ---------------------------------------------------------------------------

function(ecbuild_regex_escape input outvar)
    string(REGEX REPLACE "[][.*+?|()\\^$]" "\\\\\\0" output "${input}")
    set(${outvar} "${output}" PARENT_SCOPE)
endfunction()

macro(ecbuild_linker_flags)
  foreach(_obj EXE SHARED MODULE)
    if(ECBUILD_${_obj}_LINKER_FLAGS)
      set(CMAKE_${_obj}_LINKER_FLAGS ${ECBUILD_${_obj}_LINKER_FLAGS})
    endif()

    if(NOT "$ENV{LD_RUN_PATH}" EQUAL "")
      set(LD_RUN_PATH "$ENV{LD_RUN_PATH}")
      string(REPLACE ":" ";" LD_RUN_PATH "$ENV{LD_RUN_PATH}")
      foreach(rpath ${LD_RUN_PATH})
        ecbuild_regex_escape("${rpath}" rpath_escaped)
        if(NOT CMAKE_${_obj}_LINKER_FLAGS MATCHES ".*-Wl,-rpath,${rpath_escaped}.*")
          set(CMAKE_${_obj}_LINKER_FLAGS "${CMAKE_${_obj}_LINKER_FLAGS} -Wl,-rpath,${rpath}")
        endif()
      endforeach()
    endif()
  endforeach()
endmacro()

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

