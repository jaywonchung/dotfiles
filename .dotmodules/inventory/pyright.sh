#!/bin/bash

VERSION=${VERSION:-"14.16.0"}

cd /tmp
curl -LO "https://nodejs.org/dist/v$VERSION/node-v$VERSION-darwin-x64.tar.xz"
tar xJf "node-v$VERSION-darwin-x64.tar.xz" -C ~/.local/src
mv ~/.local/src/node* ~/.local/src/node

npm install -g pyright
