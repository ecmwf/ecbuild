<!--
(C) Copyright 2026- ECMWF.

This software is licensed under the terms of the Apache Licence Version 2.0
which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
In applying this licence, ECMWF does not waive the privileges and immunities
granted to it by virtue of its status as an intergovernmental organisation nor
does it submit to any jurisdiction.
-->

# Incremental pkg-config generation

The minimal project generates `example.pc` using `ecbuild_pkgconfig`, and
`example_sub.pc` from a subdirectory, whose generation script is configured
below that subdirectory rather than the project binary directory.
The regression checks initial generation, an unchanged rebuild, changes to
both the configured template and generation script, and a missing output.

From an ecbuild build directory:

```sh
ctest -R '^test_ecbuild_pkgconfig_incremental$' --output-on-failure
```

The test uses the parent build's generator and build tool and explicitly enables
PKGCONFIG in the nested project, independently of the parent feature setting.
It fails with the original command-bearing custom target because the unchanged
build regenerates the pkg-config file. The fix uses an output-based custom
command depending on both the configured template and script, and a
dependency-only `ALL` target. It also runs the script from the directory where
it is configured, so calls from subdirectories work.
