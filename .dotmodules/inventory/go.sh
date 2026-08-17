#!/usr/bin/env bash

set -e

VERSION=${VERSION:-1.26.3}

if [[ $(uname -m) = arm64 ]]; then
  ARCH=arm64
else
  ARCH=amd64
fi

unamestr="$(uname)"
if [[ "$unamestr" == "Darwin" ]]; then
  filename="go$VERSION.darwin-$ARCH.tar.gz"
elif [[ "$unamestr" == "Linux" ]]; then
  filename="go$VERSION.linux-$ARCH.tar.gz"
fi

rm -rf "$HOME/.local/go" || true

cd /tmp
curl -LO "https://go.dev/dl/$filename"
tar -C "$HOME/.local" -xzf "$filename"
