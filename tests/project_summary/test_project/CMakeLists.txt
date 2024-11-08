cmake_minimum_required( VERSION 3.18.4 FATAL_ERROR )
find_package( ecbuild 3.4 REQUIRED )

project( proja LANGUAGES NONE VERSION 0.2 )
ecbuild_add_option(
    FEATURE MYFEATURE
    DEFAULT ON
)

project( projb LANGUAGES NONE VERSION 0.1 )
ecbuild_add_option(
    FEATURE MYFEATURE
    DEFAULT OFF
)

ecbuild_print_summary()