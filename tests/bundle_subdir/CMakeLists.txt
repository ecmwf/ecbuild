
set( _funcs std ecbfind ecbuse )
foreach( _func ${_funcs} )
  set( _ref ${CMAKE_CURRENT_BINARY_DIR}/${_func} )
  set( _FUNC ${_func} )

  configure_file( run-test.sh.in ${_ref}/run-test.sh @ONLY )

  file( COPY mybundle/CMakeLists.txt DESTINATION ${_ref}/mybundle/ )
  configure_file( mybundle/myexe/CMakeLists.txt.in ${_ref}/mybundle/myexe/CMakeLists.txt @ONLY )

  set( _confs SYSTEM BUNDLE )
  set( _dir_SYSTEM ${_ref} )
  set( _dir_BUNDLE ${_ref}/mybundle )
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
    TARGET     bundle-subdir-${_func}
    TYPE       SCRIPT
    COMMAND    ${_ref}/run-test.sh
  )
endforeach()

