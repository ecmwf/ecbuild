ecbuild_add_library(
    TARGET circle
    TYPE SHARED
    SOURCES area.f90
)


ecbuild_add_test(
    TARGET  test_area
    SOURCES test_area.c
    LIBS    circle
)