module constructor

implicit none

TYPE :: AnimalType
  private
  integer :: m_age
contains
  procedure :: age
  procedure :: speak
ENDTYPE

! Declare constructor as interface with same name as type
interface AnimalType
  module procedure AnimalType__ctor
end interface

contains

function AnimalType__ctor(age) result(self)
  type(AnimalType) :: self
  integer :: age
  write(0,'(A)') "Constructor Animal"
  self%m_age = age
end function

function age(self)
  class(AnimalType), intent(inout) :: self
  integer :: age
  age = self%m_age
end function

subroutine speak(self)
  class(AnimalType), intent(in) :: self
  write(0,'(A)') "Animal::speak not overridden"
end subroutine

end module

! ------------------------------------------------------------------------

program test_constructor
use constructor
implicit none

  type(AnimalType) :: animal

  animal = AnimalType(8)

  write(0,'(A,I0)') "age = ",animal%age()

  call animal%speak()

end program
