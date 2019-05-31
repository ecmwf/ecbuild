# Simple ecBuild project

## Contents

The project contains two directories. The `circle` directory contains a Fortran
library and a C test of the library. The `compute` directory contains a C++
executable linking to the `circle` library as well as to LAPACK and GSL, if
they can be found on the system.

## Pointing to the libraries

The FindLAPACK macro provided by CMake looks for LAPACK in the system dynamic
linker environment variables:
* `DYLD_LIBRARY_PATH` on Apple
* `LIB` on Windows
* `LD_LIBRARY_PATH` otherwise

The FindGSL macro provided by CMake looks for the `GSL_ROOT_DIR` environment
variable. The libraries are expected to be in `$GSL_ROOT_DIR/lib` and the
headers in `$GSL_ROOT_DIR/include/gsl`. On Unix, the
`$GSL_ROOT_DIR/bin/gsl-config` tool will be used if it exists.

## Usage

```
SRC_DIR=$PWD # Source directory containing the main CMakeLists.txt
BUILD_DIR=$PWD/build # Out-of-source build directory
cd $BUILD_DIR
ecbuild $SRC_DIR
make -j
ctest
```
