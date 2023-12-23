#!/usr/bin/env bash

if [[ $(uname -m) = arm64 ]]; then
  ARCH=aarch64
else
  ARCH=x86_64
fi

unamestr="$(uname)"
if [[ "$unamestr" == "Darwin" ]]; then
  filename="rust-analyzer-$ARCH-apple-darwin.gz"
elif [[ "$unamestr" == "Linux" ]]; then
  filename="rust-analyzer-$ARCH-unknown-linux-gnu.gz"
fi

rm ~/.local/bin/rust-analyzer || true

curl -L https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/$filename \
  | gunzip -c - > ~/.local/bin/rust-analyzer
chmod +x ~/.local/bin/rust-analyzer
