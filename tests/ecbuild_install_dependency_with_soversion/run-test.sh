#!/usr/bin/env bash
set -ex

echo "HI"

TEST_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

foo_src="$TEST_ROOT/libfoo"
project_src="$TEST_ROOT/project"
foo_install="$(pwd)/foo-install"
project_install="$(pwd)/project-install"

mkdir -p foo-{build,install}
cmake \
    -B foo-build \
    -S "$foo_src" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX="$foo_install"
cmake --build foo-build --target install -j

mkdir -p project-{build,install}
cmake \
    -B project-build \
    -S "$project_src" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX="$project_install" \
    -DCMAKE_PREFIX_PATH="$foo_install" \
    -Decbuild_ROOT="$TEST_ROOT/../../"
cmake --build project-build --target install -j

lib_file_count="$(find $(pwd)/project-install \( -type f -o -type l \) -name 'libfoo.*' | wc -l)"
if [[ ! "${lib_file_count}" -eq 3 ]]; then
        echo "ERROR: Install tree is not correct"
        exit 1
fi

random=$($project_install/bin/project)
if [[ ! "${random}" -eq 4 ]]; then
        echo "ERROR: project executable did run but did not output the expected value"
        exit 1
fi
