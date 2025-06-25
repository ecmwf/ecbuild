
find_package( ecbuild 3.4 REQUIRED )

project( projb LANGUAGES NONE VERSION 0.1 )
ecbuild_add_option(
    FEATURE FEATURE_A
    DEFAULT OFF
)

ecbuild_add_option(
    FEATURE FEATURE_B
    CONDITION SOME_PACKAGE_FOUND
)
