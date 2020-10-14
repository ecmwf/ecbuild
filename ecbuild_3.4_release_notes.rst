=========================
ecBuild 3.4 Release Notes
=========================


Main changes
============

Minimal CMake version
---------------------

The minimal CMake version required is 3.11, from ecBuild 3.4. However, we
strongly encourage using the latest version.

A good compromise is to aim for a minimum of **CMake 3.12**


Including ecbuild
-----------------

There is now a more modern way to include the ecbuild macros, which is more
inline with modern CMake 3. This uses a standard find_package and avoids all the
explicit initialising of ecbuild. You will only need to call the project macro
and it will take care of the ecbuild init.

In case you intend to distribute your package inside a tarball using ``make
package_source``, you will need to update ``CMAKE_MODULE_PATH`` before calling
``find_package(ecbuild)``.

Example::

  cmake_minimum_required( VERSION 3.12 FATAL_ERROR )

  find_package( ecbuild 3.4 REQUIRED HINTS ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/../ecbuild ) # Before project() !!!

  project( eckit LANGUAGES CXX )


Project version
---------------

CMake 3.0 (via policy `CMP0048 <https://cmake.org/cmake/help/v3.11/policy/CMP0048.html>`_)
requires a project version to be provided to the ``project`` command.
Therefore, the use of ``VERSION.cmake`` files is not supported anymore.

You have 2 options:

*  Recommended: if you use the above way to initialise ecbuild, then you just
   need a VERSION file with the version string inside, eg: ``1.4.5-rc2``
*  You can provide the VERSION in the project function call, as in standard
   CMake. This however does not support adding *suffixes* to the version (eg
   -rc2) and is limited up to 4 version numbers.


Backwards compatibility
-----------------------

From ecBuild 3.4, backwards compatibility wil be disabled by default. If you
want to build a project that requires backwards compatibility, you need to pass
``-DECBUILD_2_COMPAT=ON`` on the CMake / ecBuild command line.


Library dependencies
--------------------

Modern CMake relies on properties to provide information about libraries
(include directories, preprocessor definitions, dependencies...), and most of
those properties can have specific visibility:

*  ``PRIVATE``: the property is visible only when building the library (build
   requirement)
*  ``INTERFACE``: the property is visible only in targets depending on the
   library (usage requirement)
*  ``PUBLIC``: same as using both ``PRIVATE`` and ``INTERFACE``

For convenience, ``ecbuild_add_library`` now supports the following arguments:

*  ``PRIVATE_LIBS``, ``PUBLIC_LIBS``: the library depends on those libraries
   (see *Public (interface) vs. private dependencies* if you are not sure which
   one to use), ``PUBLIC`` means that further dependencies will need to have
   those available as well (see *Transitive public dependencies*)
*  ``PRIVATE_INCLUDES``: those include directories are needed to build the
   library (note that you do not need those that come with a library target that
   declares them as ``INTERFACE`` or ``PUBLIC``)
*  ``PUBLIC_INCLUDES``: those include directories are needed to use the library
*  ``PRIVATE_DEFINITIONS``: those ``#define`` are needed to build the library
*  ``PUBLIC_DEFINITIONS``: those ``#define`` are needed to use the library

As a consequence, the ``LIBS``, ``INCLUDES``, and ``DEFINITIONS`` keywords
should not be used anymore.


ecbuild_use_package 
--------------------

The ``ecbuild_use_package`` macro should not be used anymore. It had two
distinct use cases:

*  Include a package as a sub-project: use ``add_subdirectory`` instead
*  Look for a package: use ``ecbuild_find_package`` or ``find_package`` instead
   (see also *ecbuild_find_package vs. find_package*)

For example::

  # change this ...
  ecbuild_use_package( PROJECT eckit  VERSION 1.9 REQUIRED )

  # ... to this:
  ecbuild_find_package( NAME eckit VERSION 1.9 REQUIRED )


Feature Variable names
----------------------

Feature names are now always with the original package name (not capitals). So
you may need to adapt the code as in this example::

  ecbuild_find_package( NAME metkit VERSION 1.4 REQUIRED )

  # OLD code, note the capitals
  if( NOT METKIT_HAVE_GRIB )
  ...

  # NEW code
  if( NOT metkit_HAVE_GRIB )
  ...


**Note:** that this may imply changes in the generated header files
``package_config.h.in``


Version Variables
-----------------

Variables that have the package in the name, e.g. ``<package>_VERSION`` are now
with the exact capitalisation as in the project name (no longer FULLCAPS),
similar to the feature variables mentioned above.

They also follow the CMake 3 convention for version variables with
``_VERSION_MAJOR`` instead of ``_MAJOR_VERSION`` So code and generated files
need to be adapted. 

For example, in the ``package_version.h``::

  # change this ...
  #define ECKIT_MAJOR_VERSION @ECKIT_MAJOR_VERSION@
  #define ECKIT_MINOR_VERSION @ECKIT_MINOR_VERSION@
  #define ECKIT_PATCH_VERSION @ECKIT_PATCH_VERSION@

  # ... to this:
  #define eckit_VERSION_MAJOR @eckit_VERSION_MAJOR@
  #define eckit_VERSION_MINOR @eckit_VERSION_MINOR@
  #define eckit_VERSION_PATCH @eckit_VERSION_PATCH@


get_target_property LOCATION
----------------------------

In previous versions, we still allowed an old CMake policy of using target
LOCATION. This is now deprecated and highly discouraged in new CMake 3 code. You
will need to change the code, especially in tests where you use targets just
built to use ``$<TARGET_FILE:tgt_name>``::

  #  BEFORE

  get_target_property( odc_bin odc LOCATION )
  ecbuild_add_test( NAME odc_test_foo COMMAND ${odc_bin} ... )

  #  AFTER simply call

  ecbuild_add_test( NAME odc_test_foo COMMAND $<TARGET_FILE:odc> ... )

  # OR better, if the command is the result of add_executable or ecbuild_add_executable:

  ecbuild_add_test( NAME odc_test_foo COMMAND odc ... )

**Note:**
If you use target properties in generated scripts (eg for testing), you will
need to both ``configure_file()`` and then take that and use
``file(GENERATE...)`` to obtain the ``$<TARGET_FILE:tgt_name>`` expansions in
the script.  There is a very convenient ``ecbuild_configure_file()`` that does
exactly that.::

  ecbuild_configure_file(mir-test.sh.in mir-test.sh @ONLY) # where mir-test.sh.in contains $<TARGET_FILE:mir-tool> where needed


Options and required packages
-----------------------------

Options can be declared with specific package requirements, in order to replace
boilerplate::

  ecbuild_add_option(
    FEATURE FOOBAR
    REQUIRED_PACKAGES
      "NAME foo VERSION 1.3"
      "NAME bar VERSION 4.2 COMPONENTS FOO"
  )

Every item specified in ``REQUIRED_PACKAGES`` will be passed to
``ecbuild_find_package`` unchanged, and therefore must be a suitable argument
list.

There used to be special cases for packages ``MPI``, ``OMP``, ``Python``, and
``LEXYACC``. This is not the case anymore. If you need those special cases,
please call the corresponding ``ecbuild_find_<pkg>`` macro directly and add a
``CONDITION <pkg>_FOUND`` to ``ecbuild_add_option``.


GNU-compliant install directories
---------------------------------

The default values for ``INSTALL_{BIN,INCLUDE,LIB}_DIR`` now use the
`GNUInstallDirs <https://cmake.org/cmake/help/v3.11/module/GNUInstallDirs.html>`_
CMake module to honour the GNU coding standards, in particular on 64-bit
platforms the default directory for the libraries is now ``lib64`` instead
of ``lib``.


Pitfalls
========

Public (interface) vs. private dependencies
-------------------------------------------

It may be tempting to declare all library dependencies ``PUBLIC`` to avoid
having to make the dependency graph explicit. However, this is not advised
(think of the CMake equivalent of a header file that ``#include`` all the needed
headers, both your own and the ones from external libraries, and that you would
include from every single file). Here are some guidelines to help you choose the
appropriate type of dependency for every package.

*  The dependency is an implementation detail that is not visible outside of the
   library: ``PRIVATE``
*  The dependency is a component of the library, and it makes no sense to use
   the library without it: ``PUBLIC``
*  The dependency is used within the library, but a user of the library should
   not assume that it will always be the case: ``PRIVATE``
*  Any user of the library will have to use the dependency in their code as well
   (for instance, to create objects that need to be passed to the library API):
   ``PUBLIC``
*  It has been decided that the library will expose the dependency as a
   convenience: ``PUBLIC``


Declaring public build interfaces
---------------------------------

In order to allow building software against dependencies that are in build
directories (necessary for developers daily work and for building bundles for
operations), **libraries** need to publish their build interface::

  ecbuild_add_library( NAME eccodes
      ...
  	PUBLIC_INCLUDES
         $<BUILD_INTERFACE:${PROJECT_BINARY_DIR}/src>
         $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/src>
      ...
  )


Transitive public dependencies
------------------------------

Suppose package ``packA`` exports a library ``libA``, and package ``packB``
defines the following::

  find_package(packA REQUIRED)

  ecbuild_add_library(
    NAME libB
    # ...
    PUBLIC_LIBS libA
  )

Any package using ``libB`` from ``packB`` will therefore have to look for
``libA``, and therefore ``packA`` as well. One solution is to require the user
to look for both packages::

  find_package(packA REQUIRED)
  find_package(packB REQUIRED)

But this is error-prone and inconvenient in case of API changes: How do you know
``packB`` will always require ``packA``.

The *recommended approach* is the to use the macro that CMake provides for such
cases: `find_dependency <https://cmake.org/cmake/help/latest/module/CMakeFindDependencyMacro.html>`_.

To use that macro in conjunction with ecBuild, add the following to a file
``packB-import.cmake.in``::

  include(CMakeFindDependencyMacro)
  find_dependency(packA) # you may want to specify HINTS as well, e.g. @packA_DIR@

  # Optional: further variables packB exports for use
  set(PACKB_LIBRARIES @PACKB_LIBRARIES@)

This will make sure that ``find_package(packB)`` fails with an appropriate error
message if ``packA`` cannot be found.

For example, metkit depends on eckit and optionally on eccodes and odc, when the
respective features are enabled, so the file metkit-import.cmake.in looks like::

  set( metkit_HAVE_GRIB @metkit_HAVE_GRIB@ )
  set( metkit_HAVE_ODB  @metkit_HAVE_ODB@  )


  include( CMakeFindDependencyMacro )

  find_dependency( eckit HINTS ${CMAKE_CURRENT_LIST_DIR}/../eckit @eckit_DIR@ )

  if( metkit_HAVE_GRIB )
    find_dependency( eccodes HINTS ${CMAKE_CURRENT_LIST_DIR}/../eccodes @eccodes_DIR@ )
  endif()

  if( metkit_HAVE_ODB )
    find_dependency( odc HINTS ${CMAKE_CURRENT_LIST_DIR}/../odc @odc_DIR@ )
  endif()

**Note:** when following this recommended way and assuming we drop the support
for ecbuild 2, then you can remove all the <pkg>_TPLS exports of variables. 


``ecbuild_find_package`` vs. ``find_package``
---------------------------------------------

``ecbuild_find_package`` is a wrapper around ``find_package`` with some extra
functionality to help locating packages. In particular,
``ecbuild_find_package(pkgA)`` will search the following locations, in this
order:

*  ``pkgA_BINARY_DIR``, which is defined if ``pkgA`` is a sub-project
*  ``CMAKE_MODULE_PATH``, for ``FindpkgA.cmake``
*  ``pkgA_DIR``, ``pkgA_ROOT`` (including for CMake < 3.12), ``pkgA_PATH``,
   ``PKGA_PATH`` in the CMake scope
*  ``pkgA_ROOT``, ``pkgA_PATH``, ``PKGA_PATH`` in the environment
*  ``CMAKE_PREFIX_PATH`` in the CMake scope
*  ``pkgA_DIR``, ``CMAKE_PREFIX_PATH`` in the environment


What to put into ``<project>-import.cmake``
-------------------------------------------

If your source tree contains a file named ``<project>-import.cmake`` or
``<project>-import.cmake.in``, it will be installed alongside your package, and
included by a call to ``find_package(<project>)``. You can use that to specify
additional variables, define macros, etc.

The following are strongly recommended:

*  ``find_dependency`` calls for packages that are usage requirements (see
   *Transitive public dependencies*)

The following may be useful:

*  Extra variables defining paths to resources (note that ``<project>_BASE_DIR``
   will point to the project build or install directory, depending on whether
   the project is included in the current CMake project or already installed on
   the system)
*  ``include`` calls for files containing macros or functions
   (``<project>_CMAKE_DIR`` will point to the appropriate ``lib/cmake``
   directory)

The following are not recommended, but may be provided as a convenience:

*  ``<project>_LIBRARIES``: a list of targets to link against in order to use
   the project. The user should be responsible for linking against the
   appropriate targets rather than relying on this variable

The following are deprecated and should not be provided:

*  ``<project>_INCLUDE_DIRS``: a list of include directories. Those should be
   declared as ``PUBLIC_INCLUDES`` when defining your library targets.
*  ``<project>_FOUND``: this will be set by CMake when ``find_package``
   succeeds.

::

  include( CMakeFindDependencyMacro ) # for find_dependency

  # package foo is required
  find_dependency( foo HINTS @foo_DIR@ ) # add hints as needed

  # package bar is optional, triggered by feature BAR
  set( example_HAVE_BAR @example_HAVE_BAR@ )
  if( example_HAVE_BAR )
    find_dependency( bar HINTS @bar_DIR@ )
  endif()

  # additional resources in <install-dir>/share/example
  set( example_RESOURCES ${example_BASE_DIR}/share/example )

  # some CMake macros
  include( ${example_CMAKE_DIR}/example_macros.cmake )

