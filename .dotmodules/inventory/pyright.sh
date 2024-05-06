#!/bin/bash

VERSION=${VERSION:-"17.3.0"}

if [[ $(uname -m) = arm64 ]]; then
  ARCH=arm64
else
  ARCH=x64
fi

if ! command -v node 2>&1 > /dev/null; then
  cd /tmp
  curl -LO "https://nodejs.org/dist/v$VERSION/node-v$VERSION-darwin-$ARCH.tar.xz"
  mkdir -p ~/.local/src
  tar xJf "node-v$VERSION-darwin-$ARCH.tar.xz" -C ~/.local/src
  mv ~/.local/src/node-* ~/.local/src/node
fi

npm install -g pyright
