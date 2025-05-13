cmake_minimum_required( VERSION 3.18 FATAL_ERROR )
find_package( ecbuild 3.4 REQUIRED )

project( proja LANGUAGES NONE VERSION 0.2 )
ecbuild_add_option(
    FEATURE FEATURE_A
    DEFAULT ON
)

project( projb LANGUAGES NONE VERSION 0.1 )
ecbuild_add_option(
    FEATURE FEATURE_A
    DEFAULT OFF
)

ecbuild_add_option(
    FEATURE FEATURE_B
    CONDITION SOME_PACKAGE_FOUND
)

ecbuild_print_summary()