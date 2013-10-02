list( APPEND ecbuild_bin_files
git-meld
git-mproj
ecbuild.pl
check_install.sh 
apply_license.sh
license.pl )

add_custom_target( ecbuild_bin SOURCES ${ecbuild_bin_files} )

install( FILES ${ecbuild_bin_files} DESTINATION ${INSTALL_BIN_DIR} )
