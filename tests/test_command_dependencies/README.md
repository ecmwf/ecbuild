<!--
(C) Copyright 2026- ECMWF.

This software is licensed under the terms of the Apache Licence Version 2.0
which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
In applying this licence, ECMWF does not waive the privileges and immunities
granted to it by virtue of its status as an intergovernmental organisation nor
does it submit to any jurisdiction.
-->

# Command-based test dependencies

This project reproduces repeated marker commands from `ecbuild_add_test`
when a command-based test specifies `DEPENDS`. The first default build
generates the prerequisite without running the test. A subsequent unchanged
build should not execute `cmake -E touch command_with_dependencies.x`; this is
detected from the marker file's timestamp, independently of the generator.

From an ecbuild build directory, run:

```sh
ctest -R '^test_ecbuild_command_dependencies$' --output-on-failure
```

The regression uses the parent build's generator and build tool. It also checks
that CTest executes the registered test and that changing a prerequisite input
causes the default build to regenerate its output.

The test fails on the original implementation. The dependency-only target
`add_custom_target(${_PAR_TARGET}.x ALL)` avoids repeated marker commands while
the existing `add_dependencies` call preserves prerequisite generation.
This fix is covered with Ninja and Unix Makefiles.
