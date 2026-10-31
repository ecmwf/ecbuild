<!--
SPDX-FileCopyrightText: 2026- European Centre for Medium-Range Weather Forecasts (ECMWF)
SPDX-License-Identifier: Apache-2.0
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
