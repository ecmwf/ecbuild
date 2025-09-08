program main
    implicit none
#include "mpif.h"
    integer :: ierror
    logical :: flag
    call MPI_Initialized(flag, ierror)
    write(0,*) "MPI initialized: ", flag
end program