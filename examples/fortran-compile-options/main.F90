program main
use, intrinsic :: iso_c_binding, only : c_sizeof
REAL :: variable
write(0,'("c_sizeof(REAL): ",I0)') c_sizeof(variable)


end program
