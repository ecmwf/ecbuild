============================
ecbuild - ECMWF build system
============================

Getting the sources
===================

First, retrieve ecBuild, for instance from GitHub::

   git clone https://github.com/ecmwf/ecbuild
   ECBUILD_SRC_DIR=$PWD/ecbuild

Booststrapping ecBuild
======================

ecBuild does not need to be built, however, the installation needs to be
bootstrapped::

   mkdir $TMPDIR/ecbuild # out-of-source build directory
   cd $TMPDIR/ecbuild
   ECBUILD_INSTALL_DIR=/usr/local/apps/ecbuild # where to install ecBuild
   $ECBUILD_SRC_DIR/bin/ecbuild --prefix=$ECBUILD_INSTALL_DIR $ECBUILD_SRC_DIR

Generating documentation
========================

The documentation is generated using Sphinx. Make sure that ``sphinx-build``
can be located using ``PATH`` or ``CMAKE_PREFIX_PATH``. You can either add the
``-DSPHINX_HTML=ON`` option (as well as ``-DCMAKE_PREFIX_PATH=...`` if needed)
to the above ``ecbuild`` command, or re-run ecBuild::

   cd $TMPDIR/ecbuild
   $ECBUILD_SRC_DIR/bin/ecbuild -DSPHINX_HTML=ON .
   make documentation

The documentation tree will be available in ``$TMPDIR/ecbuild/doc/html``.

Running the tests
=================

Some ecBuild features can be tested::

   cd $TMPDIR/ecbuild
   ctest

Installing
==========

By default, CMake generates a ``Makefile`` (can be overwritten with the ``-G``
command-line option, supported by both CMake and ecBuild)::

   cd $TMPDIR/ecbuild
   make install
   export PATH=$ECBUILD_INSTALL_DIR/bin:$PATH

