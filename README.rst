============================
ecbuild - ECMWF build system
============================

ecBuild is built on top of CMake and consists of a set of macros as well as a
wrapper around CMake. Calling::

   ecbuild $SRC_DIR

is equivalent to::

   cmake -DCMAKE_MODULE_PATH=$ECBUILD_DIR/cmake $SRC_DIR

Quick start
===========

ecBuild does not need to be built and installed. If you want to install it,
please refer to the ``INSTALL.rst`` file.

1. Retrieve the source code::

   git clone https://github.com/ecmwf/ecbuild

2. Add ``ecbuild`` to your ``PATH``::

   export PATH=$PWD/ecbuild/bin:$PATH

Sample projects
===============

The ``examples/`` directory contains some sample projects. To build them, you
can use the following commands::

   cd examples/simple
   mkdir build # out-of-source build directory, can be anywhere
   cd build
   ecbuild .. # see `ecbuild --help`, you may pass CMake options as well
   make
