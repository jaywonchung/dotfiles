#!/bin/bash

VERSION=${VERSION:-"17.3.0"}

cd /tmp
curl -LO "https://nodejs.org/dist/v$VERSION/node-v$VERSION-linux-x64.tar.xz"
mkdir -p ~/.local/src
tar xJf "node-v$VERSION-linux-x64.tar.xz" -C ~/.local/src
rm "node-v$VERSION-linux-x64.tar.xz"
mkdir -p ~/.local/src
mv ~/.local/src/node* ~/.local/src/node
export PATH="$HOME/.local/src/node/bin:$PATH"
npm install -g pyright
