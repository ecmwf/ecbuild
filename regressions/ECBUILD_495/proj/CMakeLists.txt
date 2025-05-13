cmake_minimum_required( VERSION 3.18 FATAL_ERROR )

find_package(ecbuild 3.4 REQUIRED)
project(foo VERSION 0.1 LANGUAGES NONE)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR/cmake})

ecbuild_find_package(Bar REQUIRED)
