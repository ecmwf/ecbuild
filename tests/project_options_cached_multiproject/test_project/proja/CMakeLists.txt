
find_package( ecbuild 3.4 REQUIRED )

project( proja LANGUAGES NONE VERSION 0.2 )

ecbuild_add_option(
    FEATURE FEATUREA
    DEFAULT ON
)

ecbuild_add_option(
    FEATURE FEATUREB
    DEFAULT OFF
)

ecbuild_add_option(
    FEATURE FEATUREC
    DEFAULT OFF
)