#!/bin/bash

if ! command -v node 2>&1 > /dev/null; then
  NODE_VERSION=${NODE_VERSION:-"23.7.0"}

  if [[ $(uname -m) = arm64 ]]; then
    ARCH=arm64
  else
    ARCH=x64
  fi

  KERNEL="$(uname | awk '{print tolower($0)}')"

  cd /tmp
  curl -LO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-$KERNEL-$ARCH.tar.xz"
  mkdir -p ~/.local/src
  tar xJf "node-v$NODE_VERSION-$KERNEL-$ARCH.tar.xz" -C ~/.local/src
  mv ~/.local/src/node-* ~/.local/src/node
fi

npm install -g pyright
