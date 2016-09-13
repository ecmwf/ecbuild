program test_c_sizeof
use, intrinsic :: iso_c_binding, only : c_size_t, c_int, c_long

write(0,*) "c_int    = ",c_int
write(0,*) "c_long   = ",c_long
write(0,*) "c_size_t = ",c_size_t

end program