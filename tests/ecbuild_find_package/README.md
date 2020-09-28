# Transitive dependencies across projects and using ecbuild_find_package

This example contains 3 projects, where projectB depends on projectA, and
projectC depends on projectB. Since projectB requires linking against projectA,
the `projectB/projectb-import.cmake.in` file propagates the dependency (it gets
included when a package calls `find_package(projectB)`). It also demonstrates
PRIVATE (build requirements) and PUBLIC (usage requirements) dependency
keywords.

projectC searches for projectB using a FindprojectB module, which in turn uses a find_package( projectB NO_MODULE )
This demonstrates that ecbuild_find_package now prioritises Find modules.

## Usage

./build-and-run.sh
