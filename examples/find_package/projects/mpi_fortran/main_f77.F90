! SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
! SPDX-License-Identifier: Apache-2.0

program main
    implicit none
#include "mpif.h"
    integer :: ierror
    logical :: flag
    call MPI_Initialized(flag, ierror)
    write(0,*) "MPI initialized: ", flag
end program