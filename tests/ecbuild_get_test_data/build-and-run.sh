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

# Same, restricted to the invocation that fetched one file.
flag_used_for() {
  grep -- "--output ./$1 " $FAKE_CURL_LOG | grep -q -- "$2"
}

build_and_download() {
  local build=$1
  shift
  rm -rf "$build"
  : > $FAKE_CURL_LOG
  ecbuild $SOURCE/test_project -B "$build" -DCURL_PROGRAM=$SOURCE/fake-curl "$@"
  # The download target fails (b.txt is refused); the point is what it does anyway.
  (cd "$build"; ctest -L download_data --output-on-failure > ctest.log 2>&1) || true
}

# --- a refused file must not abandon the rest of the set ---------------------
build_and_download $HERE/build

test -f $HERE/build/a.txt || fail "a.txt, downloaded before the failure, is missing"
test -f $HERE/build/c.txt || fail "c.txt, queued after the failure, was never attempted"
test ! -f $HERE/build/b.txt || fail "b.txt should have been refused"

# --- and the failure must name the command that failed -----------------------
grep -q "Failed downloads:" $HERE/build/ctest.log || fail "no failure summary"
grep -q "__get_data_get_stuff_b_txt" $HERE/build/ctest.log ||
  fail "the failure summary does not name the failing command"

# --- a curl that knows --retry-all-errors is asked to use it -----------------
flag_used "--retry-all-errors" || fail "modern curl was not given --retry-all-errors"
if flag_used "--http1.1"; then fail "modern curl should negotiate its own HTTP version"; fi

# --- and is left to back off on its own between retries ----------------------
# --retry-delay would replace curl's exponential backoff with a fixed wait.
if flag_used "--retry-delay"; then fail "a download was given a fixed retry delay"; fi

# --- one that does not is kept off HTTP/2 instead ----------------------------
# It could not retry a framing error, so it is not given the chance to hit one.
FAKE_CURL_OLD=1 build_and_download $HERE/build-old

flag_used "--http1.1" || fail "old curl was not pinned to HTTP/1.1"
if flag_used "--retry-all-errors"; then fail "old curl was given a flag it does not have"; fi

# --- the caller can still ask for a version explicitly -----------------------
build_and_download $HERE/build-http2 -DECBUILD_DOWNLOAD_HTTP_VERSION=2

flag_used "--http2 " || fail "ECBUILD_DOWNLOAD_HTTP_VERSION=2 was ignored"

# --- certificates are checked unless the caller says otherwise ---------------
if flag_used_for a.txt "--insecure"; then fail "a plain download skipped certificate checking"; fi
flag_used_for d.txt "--insecure" || fail "INSECURE was ignored"

build_and_download $HERE/build-insecure -DECBUILD_DOWNLOAD_INSECURE=ON
flag_used_for a.txt "--insecure" || fail "ECBUILD_DOWNLOAD_INSECURE=ON was ignored"

# --- anything else is reachable through the escape hatch ---------------------
build_and_download $HERE/build-extra "-DECBUILD_DOWNLOAD_EXTRA_FLAGS=--retry-delay;5"

flag_used "--retry-delay 5" || fail "ECBUILD_DOWNLOAD_EXTRA_FLAGS was ignored"

echo "OK"
