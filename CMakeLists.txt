############################################################################################
# cmake options:
#
#       -DCMAKE_BUILD_TYPE=Debug|RelWithDebInfo|Release|Production
#       -DCMAKE_INSTALL_PREFIX=/path/to/install
#
#       -DCMAKE_MODULE_PATH=/path/to/ecbuild/cmake
#
#       -DCMAKE_C_COMPILER=gcc
#       -DCMAKE_C_COMPILER=g++
#
#       -DCMAKE_PREFIX_PATH=/path/to/jasper:/path/to/any/package/out/of/place

cmake_minimum_required( VERSION 2.8.4 FATAL_ERROR )

project( ecbuild NONE ) # no language used, pure cmake project

set( CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake" ${CMAKE_MODULE_PATH} )

include( ecbuild_system )

###############################################################################
# local project

ecbuild_declare_project()

configure_file( cmake/ecbuild_version.h.in ${CMAKE_BINARY_DIR}/ecbuild_version.h  )

install( FILES ${CMAKE_BINARY_DIR}/ecbuild_version.h DESTINATION include/ecbuild/ )

# contents

ecbuild_add_resources(  TARGET ${PROJECT_NAME}_description_files
                        SOURCES_PACK
                            INSTALL
                            AUTHORS
                            NOTICE
                            LICENSE
                            COPYING
                            cmake/FindADSM.cmake
                            cmake/FindCMath.cmake
                            cmake/FindCairo.cmake
                            cmake/FindDl.cmake
                            cmake/FindEMOS.cmake
                            cmake/FindEcLib.cmake
                            cmake/FindFDB.cmake
                            cmake/FindGRIB_API.cmake
                            cmake/FindHPSS.cmake
                            cmake/FindLEX.cmake
                            cmake/FindLibGFortran.cmake
                            cmake/FindNDBM.cmake
                            cmake/FindNetCDF.cmake
                            cmake/FindODB.cmake
                            cmake/FindODB_API.cmake
                            cmake/FindOpenJPEG.cmake
                            cmake/FindPGIFortran.cmake
                            cmake/FindProj4.cmake
                            cmake/FindREADLINE.cmake
                            cmake/FindRPCGEN.cmake
                            cmake/FindRealtime.cmake
                            cmake/FindSZip.cmake
                            cmake/FindScin.cmake
                            cmake/FindXLFortranLibs.cmake
                            cmake/FindYACC.cmake
)

install( DIRECTORY cmake DESTINATION share/ecbuild/cmake )

add_subdirectory( tools  )

install( DIRECTORY tools DESTINATION share/ecbuild/tools )


############################################################################################
# finalize

ecbuild_install_project( NAME ecbuild )

ecbuild_print_summary()

