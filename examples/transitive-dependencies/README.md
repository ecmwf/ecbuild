# Transitive dependencies across projects

This example contains 3 projects, where projectB depends on projectA, and
projectC depends on projectB. Since projectB requires linking against projectA,
the `projectB/projectb-import.cmake.in` file propagates the dependency (it gets
included when a package calls `find_package(projectB)`). It also demonstrates
PRIVATE (build requirements) and PUBLIC (usage requirements) dependency
keywords.

## Usage

./build-and-run.sh
