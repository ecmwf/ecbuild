=========================
ecBuild 3.0 Release Notes
=========================


Minimal CMake version requirement
=================================

The minimal CMake version required for ecbuild 3 is 3.6. However we strongly
recommend to update to a more recent version when possible.


Backwards compatibility
=======================

Many breaking changes have been done in order for ecBuild and users to take
advantage of modern CMake features. In order to ensure a smooth transition, a
compatibility layer has been kept and allows to build ecbuild2-compliant
packages. However, this layer is deprecated by definition and efforts should be
made to modernise the building scripts. Deprecated features print out warnings
if the CMake variable ``ECBUILD_2_COMPAT_DEPRECATE`` is ``ON`` (add
``-DECBUILD_2_COMPAT_DEPRECATE=ON`` to the command line). The compatibility
layer can be turned off completely by setting ``ECBUILD_2_COMPAT`` to ``OFF``.
Bear in mind that packages built with the compatibility layer turned off may
break dependencies relying on this layer (for third-party libraries handling
for instance).


Modernising ecBuild code
========================

This section contains some guidelines on the tasks that need to be done in order
to modernise the code and make it work when compatibility mode is turned off.
See below for details on the specific changes and how to handle them.

1. Put the version number into the main ``CMakeLists.txt`` in the ``project``
   call
2. Replace ``REQUIRED_PACKAGES`` parameters of ``ecbuild_add_option`` by a
   combination of a ``find_package`` and ``CONDITION`` on the relevant packages.
3. Replace ``ecbuild_use_package`` by either ``add_subdirectory`` or
   ``ecbuild_find_package`` as appropriate
4. Declare a visibility for your link libraries and includes, either with
   the ``PRIVATE_*`` and ``PUBLIC_*`` parameters of ``ecbuild_add_library`` or
   by using ``target_link_libraries`` directly.
5. Advertise your usage requirements explicitly (replacement for the legacy TPL
   system)
6. Update the capitalisation of variable names


New features
============

Project declaration
-------------------

Fewer lines are now needed to enable ecBuild in a project::

  cmake_minimum_required(VERSION 3.12 FATAL_ERROR) # ecbuild requires at least 3.6

  find_package(ecbuild 3.0 REQUIRED) # note: the version requirement is optional

  project(foo VERSION 1.2 LANGUAGES C CXX)

  # define options, targets...

  ecbuild_install_project(NAME ${PROJECT_NAME})


Project version management
--------------------------

CMake now handles the version number. Instead of having a ``VERSION.cmake``
file, you should declare the version as a parameter to the ``project``
command::

  project(foo VERSION 1.2 LANGUAGES C CXX)

This automatically defines the following variables:

* ``foo_VERSION`` (the full version number)
* ``foo_VERSION_MAJOR``, ``foo_VERSION_MINOR``, ``foo_VERSION_PATCH``, and
  ``foo_VERSION_TWEAK`` for the components of the version number (in this
  order)


Variable naming conventions
---------------------------

Some variable names have been changed in order to stick with the CMake naming
schemes.


Project information
^^^^^^^^^^^^^^^^^^^

All project-related variables now use the same capitalisation as the project
itself, e.g. if the project name is ``projectA``, the version variable is
``projectA_VERSION``. This also includes variables resulting from a call to
``find_package`` (or ecBuild substitutes), like ``projectA_FOUND``.


Features and options
^^^^^^^^^^^^^^^^^^^^

For options declared with ``ecbuild_add_option``, the status can be queried by
checking ``HAVE_<feature>`` or ``<project>_HAVE_<feature>``, where ``<feature>``
and ``<project>`` have the same capitalisation as the original names. In order
to comply with CMake package components checking, dependent packages can also
use ``<project>_<feature>_FOUND``, e.g. ``projectA_TESTS_FOUND`` (where the
project name is ``projectA`` and the feature is ``TESTS``).


New macros
----------

ecbuild_configure_file
^^^^^^^^^^^^^^^^^^^^^^

This is a wrapper around `configure_file
<https://cmake.org/cmake/help/latest/command/configure_file.html>`_
and `file(GENERATE)
<https://cmake.org/cmake/help/latest/command/file.html#generate>`_, allowing to
resolve both configuration variables and generator expressions at the same time.


Target dependencies
-------------------

Modern CMake aims to make the visibility of dependencies explicit. Build-only
dependencies should be declared ``PRIVATE``, whereas usage requirements should
be declared ``INTERFACE``. The ``PUBLIC`` flag exposes them both for build-time
and as usage requirements. Bear in mind that any ``INTERFACE`` or ``PUBLIC``
requirement (library, include directory, compile flag) will be propagated
transitively to dependent targets, even when building shared libraries.


``ecbuild_add_library(PUBLIC_LIBS | PRIVATE_LIBS)``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

These parameters have been added to allow easy update of the ``LIBS`` parameter
of ``ecbuild_add_library``. This parameter is now deprecated and is only
available in compatibility mode.


Include directories and compile flags
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

With the use of targets, most include directories do not need to be set
explicitly. If a library is defined with ``ecbuild_add_library``, the
installation include directory is exported automatically. You may want to add
build-only include directories using the ``BUILD_INTERFACE`` generator
expression. In any case, the use of ``include_directories`` is not recommended,
please link include directories to the relevant targets using either the
``{PUBLIC,PRIVATE}_INCLUDES`` parameters of ``ecbuild_add_*``, or
``target_include_directories``.

The same is true for compile flags that should be explicitly associated to the
relevant targets.

As a consequence, the ``<PROJECT>_INCLUDE_DIRECTORIES`` and
``<PROJECT>_COMPILE_DEFINITIONS`` variables should not be used anymore for
CMake projects.


Bundles
-------

The way bundles (or super-builds) work has been simplified. The interface of
``ecbuild_bundle`` has not changed and is the preferred way, but it is also
possible to add "drop-in" packages just by using ``add_subdirectory``. Note
however that there should still be a call to ``ecbuild_find_package`` or
``find_package`` to explicit dependencies and make sure the needed variables
and targets are defined in the project scope. The use of
``ecbuild_use_package`` for bundles is kept only as part of the compatibility
layer.


Exported packages
-----------------

CMake files location
^^^^^^^^^^^^^^^^^^^^

The CMake package configuration files are now installed into
``lib/cmake/<project>`` instead of ``share/<project>/cmake``.


Package configuration file
^^^^^^^^^^^^^^^^^^^^^^^^^^

The way package configuration files are generated, as well as their contents,
has been modernised (see `configure_package_config_file
<https://cmake.org/cmake/help/latest/module/CMakePackageConfigHelpers.html#command:configure_package_config_file>`_
for details). The TPL handling has been removed (see below for details). The
new config file template allows dependent packages to require specific features
via the ``COMPONENTS`` parameter of ``find_package`` and
``ecbuild_find_package``. All features defined via ``ecbuild_add_option`` will
have a corresponding ``<project>_<feature>_FOUND`` variable that can be queried
from dependent packages to check whether the feature is available.


Package version file
^^^^^^^^^^^^^^^^^^^^

The version file is now directly generated by CMake (see
`write_basic_package_version_file
<https://cmake.org/cmake/help/latest/module/CMakePackageConfigHelpers.html#command:write_basic_package_version_file>`_
for details).


Package targets file
^^^^^^^^^^^^^^^^^^^^

Instead of using one targets file per build, bundles now use one file per
project.


Interface libraries
-------------------

The ``ecbuild_add_library``  macro now supports ``TYPE INTERFACE``, wrapping
`CMake INTERFACE libraries
<https://cmake.org/cmake/help/latest/command/add_library.html#interface-libraries>`_.
These libraries do not have any build stage, but can be used for
aggregating libraries, include directories and compile definitions, or for
header-only libraries. The ``PRIVATE``  visibility makes no sense for these
libraries and should not be used. The ``PUBLIC_INCLUDES``  and ``PUBLIC_LIBS``
will be used to populate the interface properties.


Fortran interfaces
------------------

The ``ecbuild_generate_fortran_interfaces`` macro now creates an INTERFACE
library target that can be linked to by using ``target_link_libraries`` or
the ``*LIBS`` parameters of ecBuild macros, the include directories will be
propagated automatically.


Deprecated / Removed features
=============================

Third-party libraries (TPL)
---------------------------

The TPL facilities are deprecated, and package maintainers should not rely on
them. Instead, in case a package has **usage** dependencies, it should ensure
they are available as well. One way of doing this is to create a file
called ``<project>-import.cmake.in`` at the top-level source directory (where
the main ``CMakeLists.txt`` is located), which will be configured (see
`configure_file
<https://cmake.org/cmake/help/latest/command/configure_file.html>`_) and loaded
by CMake when calling ``find_package`` (or an ecBuild wrapper). For instance, if
the package ``bar`` requires ``foo`` as a usage dependency, the
``bar-import.cmake.in`` file could contain::

  include(CMakeFindDependencyMacro)
  set(bar_foo_FOUND @foo_FOUND@)
  if(bar_foo_FOUND)
    find_dependency(foo 1.3 REQUIRED HINTS @foo_DIR@ @foo_BINARY_DIR@)
  endif()

Since the include directories and compile flags can (and should) be associated
to the targets, the ``<PROJECT>_LIBRARIES``, ``<PROJECT>_INCLUDE_DIRECTORIES``,
and ``<PROJECT>_COMPILE_DEFINITIONS`` variables are not exported anymore
(except in the compatibility layer).


ecbuild_use_package
-------------------

The ``ecbuild_use_package``  macro is only available in compatibility mode and
should not be used anymore. This macro had two different use cases, which
should be replaced by different code, as suggested in the following.


Include a package as a sub-project
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This behaviour allows to import a package provided as a source code
subdirectory, either by setting ``<PROJECT>_SOURCE_DIR`` , or by matching the
package name with the name of an actual subdirectory. This should be replaced
by a direct call to ``add_subdirectory``.


Look for a package
^^^^^^^^^^^^^^^^^^

This behaviour is equivalent to ``ecbuild_find_package``, which should be used
as a replacement.


Extra targets
-------------

The special targets ``execs``, ``libs``, ``and`` ``links`` has been removed.


C++11 feature checking
----------------------

ecbuild_add_cxx11_flags
^^^^^^^^^^^^^^^^^^^^^^^

This macro is only available in compatibility mode and should not be used
anymore. CMake can handle C++ standard requirements directly::

  set(CMAKE_CXX_STANDARD 11)
  set(CMAKE_CXX_STANDARD_REQUIRED ON)


ecbuild_check_cxx11
^^^^^^^^^^^^^^^^^^^

This function has been removed, a placeholder is available in compatibility
mode. If you want to check for specific features, see the
`CMAKE_CXX_COMPILE_FEATURES
<https://cmake.org/cmake/help/latest/variable/CMAKE_CXX_COMPILE_FEATURES.html>`_
variable.


Package search path manipulation macros
---------------------------------------

The ``ecbuild_add_extra_search_paths`` and ``ecbuild_list_extra_search_paths``
macros have been removed, since the package search paths are handled by
``ecbuild_find_package`` and ``find_package`` directly.


ecbuild_add_option(REQUIRED_PACKAGES)
-------------------------------------

The ``REQUIRED_PACKAGES`` of ``ecbuild_add_option`` is only available in
compatibility mode and should not be used anymore. Instead, check for the
package before and use ``CONDITION``::

  find_package(foo 1.3 QUIET) # or ecbuild_find_package
  ecbuild_add_option(FEATURE FOO CONDITION foo_FOUND)

The behaviour of ``REQUIRED_PACKAGES`` is as follows, you may want to mimic that
functionality:

1. ``REQUIRED_PACKAGES`` takes a list of strings, each one representing a
   package requirement. If the string starts with ``PROJECT``, it should
   contains valid arguments for a direct call to ``ecbuild_use_package``.
   Otherwise, you can use either ``ecbuild_find_package`` or ``find_package``.
   We recommend using ``ecbuild_find_package`` for ECMWF software built with
   ecBuild.
2. Some special cases were present in the ``REQUIRED_PACKAGES`` handling:
   requiring ``MPI``, ``OMP``, ``Python``, or ``LEXYACC`` called the
   corresponding ``ecbuild_find_*`` macro.


ecbuild_generate_rpc
--------------------

This macro is deprecated and only available in compatibility mode.


External "contrib" modules
--------------------------

GreatCMakeCookOff
^^^^^^^^^^^^^^^^^

The files imported from the `GreatCMakeCookOff repository on GitHub
<https://github.com/UCL/GreatCMakeCookOff>`_ have been removed


CMake 3.7 modules
^^^^^^^^^^^^^^^^^

The modules ``CheckFortranCompilerFlag.cmake``,
``CheckFortranSourceCompiles.cmake``, and
``CMakeCheckCompilerFlagCommonPatterns.cmake`` were backported from CMake 3.7,
and have now been removed since they also exist in CMake 3.6.


Find*.cmake
-----------

In order to reduce the amount of code to maintain within ecBuild, many
Find*.cmake scripts have been removed. If your project has specific needs,
please include the appropriate scripts in the ``cmake/`` directory. Here is a
list of the modules that have been removed:

* contrib/FindNumPy.cmake
* contrib/GreatCMakeCookOff/FindEigen.cmake
* FindADSM.cmake
* FindAEC.cmake
* FindAIO.cmake
* FindArmadillo.cmake
* FindHPSS.cmake
* FindLibGFortran.cmake
* FindLibIFort.cmake
* FindLustreAPI.cmake
* FindNAG.cmake (still available in compat mode)
* FindNDBM.cmake
* FindNetCDF3.cmake (still available in compat mode)
* FindOpenCL.cmake
* FindOpenJPEG.cmake
* FindPGIFortran.cmake
* FindProj4.cmake
* FindREADLINE.cmake
* FindRealtime.cmake
* FindRPC.cmake
* FindRPCGEN.cmake
* Findspot.cmake
* FindSZip.cmake
* FindTrilinos.cmake
* FindViennaCL.cmake
* FindXLFortranLibs.cmake


Boost unit tests
----------------

The ``BOOST`` keyword has been removed from ``ecbuild_add_test``, as well as
all associated facilities. Boost unit tests can still be used but the user is
responsible for linking to Boost libraries.


ecbuild_bundle(STASH)
---------------------

The ``STASH`` keyword of ``ecbuild_bundle`` is ECMWF-specific and requires
hardcoding some internal URLs into the ecBuild source code. Therefore, it is
only available in compatibility mode and should not be used anymore. Please put
the full git URL instead (you may want to use a variable to enable easy
changes).

