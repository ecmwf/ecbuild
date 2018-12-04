
configure_file( run-test.sh.in run-test.sh @ONLY )

file( COPY mybundle DESTINATION . )

set( _confs SYSTEM BUNDLE )
set( _dir_SYSTEM ${CMAKE_CURRENT_BINARY_DIR} )
set( _dir_BUNDLE ${CMAKE_CURRENT_BINARY_DIR}/mybundle )
foreach( _conf ${_confs} )
  set( _dir ${_dir_${_conf}} )
  set( _CONFNAME ${_conf} )

  file( GLOB_RECURSE _infiles
        RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}/mylib.in
        "${CMAKE_CURRENT_SOURCE_DIR}/mylib.in/*" )
  foreach( _infile ${_infiles} )
    configure_file( mylib.in/${_infile} ${_dir}/mylib/${_infile} @ONLY )
  endforeach()
endforeach()

ecbuild_add_test(
  TARGET     bundle-subdir
  TYPE       SCRIPT
  COMMAND    run-test.sh
)

