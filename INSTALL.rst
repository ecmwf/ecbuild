==================
Installing ecBuild
==================

Bootstrap and install
=====================

::

   git clone https://github.com/ecmwf/ecbuild

   cd ecbuild

   mkdir bootstrap

   cd bootstrap

   ../bin/ecbuild --prefix=/path/to/install/ecbuild ..

   ctest

   make install

Generating documentation
========================

The documentation is generated using Sphinx. Make sure that ``sphinx-build``
can be located using ``PATH`` or ``CMAKE_PREFIX_PATH``. You can either add the
``-DSPHINX_HTML=ON`` option (as well as ``-DCMAKE_PREFIX_PATH=...`` if needed)
to the above ``ecbuild`` command, or re-run ecBuild::

   cd ecbuild/bootstrap

   ../bin/ecbuild -DSPHINX_HTML=ON ..

   make documentation

The documentation tree will be available in ``doc/html``.

