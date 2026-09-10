# SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
# SPDX-License-Identifier: Apache-2.0

############################################################################################
# check endiness

function(ecbuild_test_endiness)

    test_big_endian( _BIG_ENDIAN )

    if( _BIG_ENDIAN )
        set( EC_BIG_ENDIAN    1 )
        set( EC_LITTLE_ENDIAN 0 )
    else()
        set( EC_BIG_ENDIAN    0 )
        set( EC_LITTLE_ENDIAN 1 )
    endif()

  set( EC_BIG_ENDIAN    ${EC_BIG_ENDIAN}    PARENT_SCOPE )
  set( EC_LITTLE_ENDIAN ${EC_LITTLE_ENDIAN} PARENT_SCOPE )

endfunction(ecbuild_test_endiness)

