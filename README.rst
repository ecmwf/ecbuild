============================
ecbuild - ECMWF build system
============================

ecBuild is built on top of CMake and consists of a set of macros as well as a
wrapper around CMake. Calling::

   ecbuild $SRC_DIR

is equivalent to::

   cmake -DCMAKE_MODULE_PATH=$ECBUILD_DIR/cmake $SRC_DIR

Prior knowledge of CMake is assumed. For a tutorial, see e.g.
https://cmake.org/cmake/help/latest/guide/tutorial/index.html

Quick start
===========

ecBuild does not need to be compiled, and can be used directly from the source
repository. If you want to install it, please refer to the `<INSTALL.rst>`_
file.

1. Retrieve the source code::

   git clone https://github.com/ecmwf/ecbuild

2. Add ``ecbuild`` to your ``PATH``::

   export PATH=$PWD/ecbuild/bin:$PATH

Examples
========

The `examples/ <examples/README.rst>`_ directory contains some sample projects
that show how ecBuild can be used in various situations. For a quick
introduction on how to write an ecBuild project, have a look at
`<examples/simple/CMakeLists.txt>`_.

Building a project
==================

Just like CMake, ecBuild uses out-of-source builds. We will assume that your
project sources are in ``$SRC_DIR`` (e.g. ``examples/simple``), and that your
build directory is ``$BUILD_DIR`` (e.g. ``$SRC_DIR/build``)::

   mkdir -p $BUILD_DIR
   cd $BUILD_DIR
   ecbuild $SRC_DIR    # see `ecbuild --help`, you may pass CMake options as well
   make                # add your favourite options, e.g. -j

