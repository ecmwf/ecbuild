! SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
! SPDX-License-Identifier: Apache-2.0

program main
use, intrinsic :: iso_c_binding, only : c_sizeof
REAL :: variable
write(0,'("c_sizeof(REAL): ",I0)') c_sizeof(variable)


end program
