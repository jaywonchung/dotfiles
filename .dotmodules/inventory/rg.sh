#!/bin/bash

VERSION=${VERSION:-"12.1.1"}

cd /tmp
curl -LO "https://github.com/BurntSushi/ripgrep/releases/download/$VERSION/ripgrep-$VERSION-x86_64-unknown-linux-musl.tar.gz"
tar xzf "ripgrep-$VERSION-x86_64-unknown-linux-musl.tar.gz"
cp "ripgrep-$VERSION-x86_64-unknown-linux-musl/rg" ~/.local/bin/
