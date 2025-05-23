
find_package( ecbuild 3.4 REQUIRED )

project( projb LANGUAGES NONE VERSION 0.1 )

ecbuild_add_option(
    FEATURE FEATUREA
    DEFAULT OFF
)

ecbuild_add_option(
    FEATURE FEATUREB
    DEFAULT ON
)

ecbuild_add_option(
    FEATURE FEATUREC
    DEFAULT OFF
)