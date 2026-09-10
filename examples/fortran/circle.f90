! SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
! SPDX-License-Identifier: Apache-2.0

MODULE Circle
USE Constants, ONLY : ZOOM
!---------------------------------------------------------------------
!
!  Module containing definitions of variables needed to
!  compute the area of a circle of radius r
!
!---------------------------------------------------------------------
   REAL, PARAMETER :: Pi = 3.1415927 * ZOOM
   REAL :: radius
END MODULE Circle