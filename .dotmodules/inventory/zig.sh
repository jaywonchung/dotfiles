#!/usr/bin/env bash

set -ev

VERSION="${VERSION:-0.16.0}"

unamestr="$(uname)"
if [[ "$unamestr" == "Darwin" ]]; then
  OS=macos
elif [[ "$unamestr" == "Linux" ]]; then
  OS=linux
else
  echo "I never thought about $unamestr"
  exit 1
fi
archstr="$(uname -m)"
if [[ "$archstr" == "x86_64" ]]; then
  ARCH=x86_64
elif [[ "$archstr" == "arm64" ]]; then
  ARCH=aarch64
else
  echo "I never thought about $archstr"
  exit 1
fi

cd /tmp
curl -LO "https://ziglang.org/download/$VERSION/zig-$ARCH-$OS-$VERSION.tar.xz"
rm -r ~/.local/zig || true
tar xf "zig-$ARCH-$OS-$VERSION.tar.xz"
mv "zig-$ARCH-$OS-$VERSION" ~/.local/zig
rm "zig-$ARCH-$OS-$VERSION.tar.xz"
ln -s "$HOME/.local/zig/zig" "$HOME/.local/bin/zig"

curl -LO "https://github.com/zigtools/zls/releases/download/$VERSION/zls-$ARCH-$OS.tar.xz"
tar xf "zls-$ARCH-$OS.tar.xz"
mv zls ~/.local/bin
rm "zls-$ARCH-$OS.tar.xz"
