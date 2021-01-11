#!/bin/bash

VERSION=${VERSION:-"0.17.1"}

cd /tmp
curl -LO "https://github.com/sharkdp/bat/releases/download/v$VERSION/bat-v$VERSION-x86_64-apple-darwin.tar.gz"
tar xzvf "bat-v$VERSION-x86_64-apple-darwin.tar.gz"
cp "bat-v$VERSION-x86_64-apple-darwin/bat" ~/.local/bin/
