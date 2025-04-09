
find_package( ecbuild 3.4 REQUIRED )

project( projb LANGUAGES NONE VERSION 0.2 )
ecbuild_add_option(
    FEATURE FEATURE_A
    DEFAULT OFF
    CONDITION SOME_PACKAGE_FOUND
)
