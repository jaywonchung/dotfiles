#!/usr/bin/env bash

VERSION=2.71.2

if [[ $(uname -m) = arm64 ]]; then
  ARCH=arm64
else
  ARCH=amd64
fi

if [[ $(uname -s) = Darwin ]]; then
  PLATFORM=macOS
else
  PLATFORM=linux
fi

mkdir -p "$HOME/.local/bin"

cd /tmp
wget https://github.com/cli/cli/releases/download/v$VERSION/gh_${VERSION}_${PLATFORM}_$ARCH.tar.gz
tar xzf gh_${VERSION}_${PLATFORM}_${ARCH}.tar.gz
mv gh_${VERSION}_${PLATFORM}_${ARCH}/bin/gh "$HOME/.local/bin/gh"
rm -rf gh_${VERSION}_${PLATFORM}_${ARCH} gh_${VERSION}_${PLATFORM}_${ARCH}.tar.gz
