program main
    use mpi, only : MPI_Initialized
    implicit none
    integer :: ierror
    logical :: flag
    call MPI_Initialized(flag, ierror)
    write(0,*) "MPI initialized: ", flag
end program