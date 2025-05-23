cmake_minimum_required( VERSION 3.18 FATAL_ERROR )
find_package( ecbuild 3.4 REQUIRED )

project( project LANGUAGES NONE VERSION 0.2 )

ecbuild_add_option(
    FEATURE FEATUREA
    DEFAULT OFF
)

ecbuild_add_option(
    FEATURE FEATUREB
    DEFAULT ON
)