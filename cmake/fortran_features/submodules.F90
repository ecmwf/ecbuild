module sb_module
implicit none
integer :: a = 1

interface
  module subroutine sb
  end subroutine
end interface

contains
end module sb_module

! -------------------------------------------------------

submodule (sb_module) sb_submod1
implicit none
integer :: b = 2

contains

module subroutine sb()
  a = b
end subroutine

end submodule sb_submod1

! -------------------------------------------------------

program test_submodule
use sb_module
implicit none
write(0,*) a
call sb()
write(0,*) a
end program