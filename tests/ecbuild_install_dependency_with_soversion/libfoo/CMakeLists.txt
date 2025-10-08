cmake_minimum_required(VERSION 3.18 FATAL_ERROR)
project(foo VERSION 1.33.7 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

add_library(foo SHARED
    src/foo.cc
)
target_include_directories(foo
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/src/include>
        $<INSTALL_INTERFACE:include>
)
set_target_properties(foo
    PROPERTIES
        VERSION ${PROJECT_VERSION}
        SOVERSION ${PROJECT_VERSION_MAJOR}
        PUBLIC_HEADER "src/include/foo/foo.h"
)
add_executable(foo_test
    src/test_foo.cc
)
target_link_libraries(foo_test PRIVATE foo)

include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

install(
    TARGETS foo
    EXPORT fooTargets
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/foo
)
install(
    EXPORT fooTargets
    FILE fooTargets.cmake
    NAMESPACE foo::
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/foo
)
write_basic_package_version_file(
    "${CMAKE_CURRENT_BINARY_DIR}/fooConfigVersion.cmake"
    VERSION ${PROJECT_VERSION}
    COMPATIBILITY SameMajorVersion
)
install(FILES
    ${CMAKE_CURRENT_LIST_DIR}/cmake/fooConfig.cmake
    ${CMAKE_CURRENT_BINARY_DIR}/fooConfigVersion.cmake
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/foo
)
