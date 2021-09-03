#!/bin/bash

VERSION=${VERSION:-"13.0.0"}

cd /tmp
curl -LO "https://github.com/BurntSushi/ripgrep/releases/download/$VERSION/ripgrep-$VERSION-x86_64-apple-darwin.tar.gz"
tar xzf "ripgrep-$VERSION-x86_64-apple-darwin.tar.gz"
mv "ripgrep-$VERSION-x86_64-apple-darwin/rg" ~/.local/bin/
