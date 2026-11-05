#!/bin/sh
# Perform the various build tests.
# Usage: sh build-test.sh top-srcdir stage0|bootstrap
#
# These tests are written here to keep all the shell complexity out of the
# Makefile.

# Strict error checking
set -eu -o pipefail

if test $# -ne 2
then
  echo >&2 "Usage: build-test.sh top-srcdir stage0|bootstrap"
  exit 1
fi

top_srcdir=$1
kind=$2

TESTDIR="build-$kind"

check_stage0_dir() {
  if test ! -d "$top_srcdir/stage0"
  then
    echo >&2 "$top_srcdir/stage0 missing, unable to run test"
    echo "test-$kind: UNTESTED"
    exit 0
  fi
}

prep_testdir() {
  testdir=$1
  rm -rf "$testdir"
  mkdir "$testdir"
}

case $kind in
stage0-source)
  prep_testdir "$TESTDIR"
  cd "$TESTDIR"
  "$top_srcdir/configure" --disable-bootstrap --without-packages \
    --prefix=`pwd`/discard
  make base-system
  make stage0-source
  # We could test for more files, but this is good enough for now.
  if test ! -f stage0/system.bas
  then
    echo >&2 "make stage0-source failed, system.bas not present"
    exit 1
  fi
  ;;
stage0)
  check_stage0_dir
  prep_testdir "$TESTDIR"
  cd "$TESTDIR"
  "$top_srcdir/configure" --enable-stage0-build --without-packages \
    --prefix=`pwd`/discard
  make build-stage0
  ;;
bootstrap)
  check_stage0_dir
  prep_testdir "$TESTDIR"
  cd "$TESTDIR"
  mkdir bin
  # Make sure there is no valid RS in $PATH.
  cat >bin/rs <<EOF
#!/bin/sh
echo >&2 "BAD RS INVOKED, ARGS: $@"
exit 1
EOF
  chmod +x bin/rs
  PATH=`pwd`/bin:$PATH
  # Print which rs is found for assurance purposes.
  echo "\$PATH RS for bootstrap test is: `which rs`"
  "$top_srcdir/configure" --enable-bootstrap --without-packages \
    --prefix=`pwd`/discard
  make bootstrap
  make all
  make rsc
  ;;
*)
  echo >&2 "Error: invalid build test kind: $kind"
  exit 1
  ;;
esac

echo "test-$kind: PASS"
