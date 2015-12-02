FUNCTION area_circle(r)
IMPLICIT NONE

REAL*8, PARAMETER :: Pi = 3.1415927
REAL*8, INTENT(IN) :: r
REAL*8 :: area_circle

area_circle = Pi * r * r
RETURN

END FUNCTION area_circle