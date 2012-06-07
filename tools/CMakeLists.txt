# define the script to build the persistent class information
set( sg_perl ${CMAKE_CURRENT_SOURCE_DIR}/sg.pl PARENT_SCOPE )

add_custom_target( ecbuild_tools 
                   SOURCES 
                    sg.pl 
                    insert_license.sh
                    license_header.txt
                    license.pl )
