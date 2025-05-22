
find_package( ecbuild 3.4 REQUIRED )

project( projc LANGUAGES NONE VERSION 0.3 )
ecbuild_add_option(
    FEATURE FEATURE_C
    DEFAULT ON
    REQUIRED_PACKAGES NONEXISTENT
)
