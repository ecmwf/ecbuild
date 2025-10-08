cmake_minimum_required( VERSION 3.18 FATAL_ERROR )
find_package(ecbuild 3.12 REQUIRED HINTS ${CMAKE_SOURCE_DIR})
project(project VERSION 1.0 LANGUAGES CXX)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_BUILD_WITH_INSTALL_RPATH ON)
set(CMAKE_INSTALL_RPATH_USE_LINK_PATH OFF)
ecbuild_find_package(NAME foo VERSION 1.33 REQUIRED)

ecbuild_add_executable(
    TARGET project
    SOURCES main.cc
    LIBS foo::foo
)
ecbuild_install_dependency_with_soversion(foo::foo)

ecbuild_add_executable(
    TARGET project_copy
    SOURCES main.cc
    LIBS foo::foo
)
ecbuild_install_dependency_with_soversion(foo::foo)
