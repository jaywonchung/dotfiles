#!/bin/bash

if [[ $(uname -m) = arm64 ]]; then
  ARCH=aarch64
else
  ARCH=x86_64
fi

curl -L https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/rust-analyzer-$ARCH-apple-darwin.gz \
  | gunzip -c - > ~/.local/bin/rust-analyzer
chmod +x ~/.local/bin/rust-analyzer
