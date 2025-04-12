#!/usr/bin/env bash

if [[ $(uname -m) = arm64 ]]; then
  ARCH=aarch64
else
  ARCH=x86_64
fi

mkdir -p "$HOME/.local/bin"

cd /tmp
wget https://github.com/latex-lsp/texlab/releases/latest/download/texlab-$ARCH-macos.tar.gz
tar xzf texlab-$ARCH-macos.tar.gz
rm texlab-$ARCH-macos.tar.gz
mv texlab "$HOME/.local/bin"
