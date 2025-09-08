# Specify "MPI_HOME" in environment

cmake_minimum_required( VERSION 3.18 FATAL_ERROR )
project( find_mpi_fortran VERSION 0.0.0 LANGUAGES Fortran )

# set(CMAKE_FIND_DEBUG_MODE TRUE)

find_package( MPI REQUIRED COMPONENTS Fortran )

message( "MPI_FOUND                       : ${MPI_FOUND}" )
message( "MPI_Fortran_FOUND               : ${MPI_Fortran_FOUND}" )
message( "MPI_Fortran_VERSION             : ${MPI_Fortran_VERSION}" )
message( "MPI_Fortran_LIBRARIES           : ${MPI_Fortran_LIBRARIES}" )
message( "MPI_Fortran_INCLUDE_DIRS        : ${MPI_Fortran_INCLUDE_DIRS}" )
message( "MPI_Fortran_LINK_FLAGS          : ${MPI_Fortran_LINK_FLAGS}" )
message( "MPI_Fortran_COMPILE_OPTIONS     : ${MPI_Fortran_COMPILE_OPTIONS}" )
message( "MPI_Fortran_COMPILE_DEFINITIONS : ${MPI_Fortran_COMPILE_DEFINITIONS}" )
message( "MPI_Fortran_HAVE_F77_HEADER     : ${MPI_Fortran_HAVE_F77_HEADER}" )
message( "MPI_Fortran_HAVE_F90_MODULE     : ${MPI_Fortran_HAVE_F90_MODULE}" )
message( "MPI_Fortran_HAVE_F08_MODULE     : ${MPI_Fortran_HAVE_F08_MODULE}" )

message( "MPIEXEC_EXECUTABLE              : ${MPIEXEC_EXECUTABLE}" )
message( "MPIEXEC_NUMPROC_FLAG            : ${MPIEXEC_NUMPROC_FLAG}" )
message( "MPIEXEC_MAX_NUMPROCS            : ${MPIEXEC_MAX_NUMPROCS}" )
message( "MPIEXEC_PREFLAGS                : ${MPIEXEC_PREFLAGS}" )
message( "MPIEXEC_POSTFLAGS               : ${MPIEXEC_POSTFLAGS}" )
enable_testing()

if ( MPI_Fortran_HAVE_F77_HEADER )
    add_executable(main_f77 main_f77.F90)
    target_link_libraries(main_f77 PUBLIC MPI::MPI_Fortran)
    add_test(test_mpi_fortran_f77 main_f77)
endif()

if ( MPI_Fortran_HAVE_F90_MODULE )
    add_executable(main_f90 main_f90.F90)
    target_link_libraries(main_f90 PUBLIC MPI::MPI_Fortran)
    add_test(test_mpi_fortran_f90 main_f90)
endif()

if ( MPI_Fortran_HAVE_F08_MODULE )
    add_executable(main_f08 main_f08.F90)
    target_link_libraries(main_f08 PUBLIC MPI::MPI_Fortran)
    add_test(test_mpi_fortran_f08 main_f08)
endif()