#!/bin/sh
# Test building the system
# This script only tests the checked in version of the current branch.
# It's existence is temporary pending support for separate build directories.
# Usage: sh build-test.sh base|packages

set -x

# Strict error checking
set -eu -o pipefail

if test ! -f build-test.sh
then
  echo >&2 "Must run this script from <top-src-dir>/test"
  exit 1
fi

if test $# -ne 1
then
  echo >&2 "Usage: build-test.sh base|packages"
  exit 1
fi

CMD=$1
case "$CMD" in
base | package) ;;
*)
  echo >&2 "Invalid command: $CMD"
  exit 1
  ;;
esac

TOP_SRC_DIR=`cd .. && pwd`
BUILD_DIR=`pwd`/test.build
PREFIX_DIR="$BUILD_DIR/release"
CURRENT_BRANCH=`git branch --show-current`

# We don't support building outside of the source tree.
# Rather than polluting the source tree make a copy.
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"
git clone "$TOP_SRC_DIR"
cd rscheme
git switch "$CURRENT_BRANCH"

make base_system BUILD_ID='"v0.7.3.5-b1, asis"'
cd src
./configure --prefix="$PREFIX_DIR"
make all
make rsc

if test "$CMD" = packages
then
  PATH="$PREFIX_DIR/bin:$PATH" make packages \
    PACKAGES="general fasl syscalls unixm lss calendar sets threads"
fi
