cmake_minimum_required( VERSION 3.18 FATAL_ERROR )

find_package( ecbuild REQUIRED )
project( test_ecbuild_get_test_data VERSION 0.1.0 LANGUAGES NONE )

# b.txt is the one fake-curl refuses; a.txt and c.txt must arrive regardless.
ecbuild_get_test_multidata( TARGET get_stuff NOCHECK NAMES a.txt b.txt c.txt )
