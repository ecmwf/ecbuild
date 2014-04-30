list( APPEND ecbuild_bin_files
cmake_ecbuild
git-meld
git-mproj
ecbuild.pl
check_install.sh 
apply_license.sh
license.pl )

add_custom_target( ecbuild_bin SOURCES ${ecbuild_bin_files} )

if( ENABLE_INSTALL )

	install( PROGRAMS cmake_ecbuild DESTINATION ${INSTALL_BIN_DIR} )

#	install( PROGRAMS ${ecbuild_bin_files} DESTINATION ${INSTALL_BIN_DIR} )

endif()
