! SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
! SPDX-License-Identifier: Apache-2.0

program main
    use mpi_f08, only : MPI_Initialized
    implicit none
    integer :: ierror
    logical :: flag
    call MPI_Initialized(flag, ierror)
    write(0,*) "MPI initialized: ", flag
end program