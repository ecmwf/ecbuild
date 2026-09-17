! SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
! SPDX-License-Identifier: Apache-2.0

!-----Area_Circle----------------------------------------------------
!
!  Function to compute the area of a circle of given radius
!
!---------------------------------------------------------------------
FUNCTION Area_Circle(r)
USE Circle, ONLY : Pi

IMPLICIT NONE
REAL :: Area_Circle
REAL, INTENT(IN) :: r

Area_Circle = Pi * r * r

END FUNCTION Area_Circle