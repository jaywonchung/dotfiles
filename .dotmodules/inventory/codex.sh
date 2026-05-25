#!/usr/bin/env bash

set -e

if [[ $(uname -m) = arm64 ]]; then
  ARCH=aarch64
else
  ARCH=x86_64
fi

unamestr="$(uname)"
if [[ "$unamestr" == "Darwin" ]]; then
  filename="codex-$ARCH-apple-darwin.tar.gz"
elif [[ "$unamestr" == "Linux" ]]; then
  filename="codex-$ARCH-unknown-linux-musl.tar.gz"
fi

rm ~/.local/bin/codex || true

curl -L https://github.com/openai/codex/releases/latest/download/$filename | tar xzf -
chmod +x ${filename%.tar.gz}
mv ${filename%.tar.gz} ~/.local/bin/codex
