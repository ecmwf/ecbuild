cmake_minimum_required( VERSION 3.18 FATAL_ERROR )

find_package( ecbuild REQUIRED )
project( test_test_processors VERSION 0.1.0 LANGUAGES NONE )

# The tests are only listed, never run: any launcher will do
set( MPIEXEC_EXECUTABLE echo )

ecbuild_add_test( TARGET serial COMMAND true )
ecbuild_add_test( TARGET omp4 OMP 4 COMMAND true )
ecbuild_add_test( TARGET mpi2_omp3 MPI 2 OMP 3 COMMAND true )
ecbuild_add_test( TARGET mpi2_overridden MPI 2 TEST_PROPERTIES PROCESSORS 3 COMMAND true )
