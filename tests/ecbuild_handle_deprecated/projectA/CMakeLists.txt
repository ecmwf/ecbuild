cmake_minimum_required( VERSION 3.18 FATAL_ERROR )

find_package( ecbuild REQUIRED )
project( projectA VERSION 0.0.1 LANGUAGES CXX )

# This project performs no build actions.
# It exists only to verify that the project is configured without issuing deprecation warnings.
