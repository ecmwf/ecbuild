#!/usr/bin/env bash

set -e

HERE=${CMAKE_CURRENT_BINARY_DIR:-"$( cd $( dirname "${BASH_SOURCE[0]}" ) && pwd -P )"}
SOURCE=${CMAKE_CURRENT_SOURCE_DIR:-$HERE}

# Add ecbuild to path
export PATH=$SOURCE/../../bin:$PATH

export FAKE_CURL_LOG=$HERE/curl.log

fail() {
  echo "FAIL: $*"
  exit 1
}

# There is one curl invocation per file, so the flags are asserted on the
# recorded command line rather than on any observable download behaviour.
# Only the download invocations count: the capability probe is in the log too,
# and it names --retry-all-errors whatever the answer turns out to be.
flag_used() {
  grep -- "--output" $FAKE_CURL_LOG | grep -q -- "$1"
}

build_and_download() {
  local build=$1
  shift
  rm -rf "$build"
  : > $FAKE_CURL_LOG
  ecbuild $SOURCE/test_project -B "$build" -DCURL_PROGRAM=$SOURCE/fake-curl "$@"
  (cd "$build"; ctest -L download_data --output-on-failure > ctest.log 2>&1) || true
}

# --- a curl that knows --retry-all-errors is asked to use it -----------------
build_and_download $HERE/build

flag_used "--retry-all-errors" || fail "modern curl was not given --retry-all-errors"
if flag_used "--http1.1"; then fail "modern curl should negotiate its own HTTP version"; fi

# --- one that does not is kept off HTTP/2 instead ----------------------------
# It could not retry a framing error, so it is not given the chance to hit one.
FAKE_CURL_OLD=1 build_and_download $HERE/build-old

flag_used "--http1.1" || fail "old curl was not pinned to HTTP/1.1"
if flag_used "--retry-all-errors"; then fail "old curl was given a flag it does not have"; fi

# --- the caller can still ask for a version explicitly -----------------------
build_and_download $HERE/build-http2 -DECBUILD_DOWNLOAD_HTTP_VERSION=2

flag_used "--http2 " || fail "ECBUILD_DOWNLOAD_HTTP_VERSION=2 was ignored"

echo "OK"
