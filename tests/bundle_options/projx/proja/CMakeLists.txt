
find_package( ecbuild 3.4 REQUIRED )

project( proja LANGUAGES NONE VERSION 0.1 )
ecbuild_add_option(
    FEATURE FEATURE_A
    DEFAULT ON
)
