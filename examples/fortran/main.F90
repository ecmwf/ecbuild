PROGRAM Area
!---------------------------------------------------------------------
!
!  This program computes the area of a circle given the input radius
!
!  Uses:  MODULE Circle
!         FUNCTION Area_Circle (r)
!
!---------------------------------------------------------------------

USE Circle, ONLY : radius
IMPLICIT NONE

#include "area_circle.h"

!  Prompt user for radius of circle
write(*, '(A)', ADVANCE = "NO") "Enter the radius of the circle:  "
read(*,*) radius

! Write out area of circle using function call
write(*,100) "Area of circle with radius", radius, " is", &
            Area_Circle(radius)
100 format (A, 2x, F6.2, A, 2x, F11.2)

END PROGRAM Area