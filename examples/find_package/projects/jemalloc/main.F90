program main
implicit none
real(8), allocatable :: a(:)
allocate(a(32))
a(:)=1.
write(6,'(F8.6)') a(1)
end program