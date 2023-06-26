#!/bin/bash

VERSION=${VERSION:-"0.23.0"}

cd /tmp
curl -LO "https://github.com/sharkdp/bat/releases/download/v$VERSION/bat-v$VERSION-x86_64-unknown-linux-gnu.tar.gz"
tar xzvf "bat-v$VERSION-x86_64-unknown-linux-gnu.tar.gz"
cp "bat-v$VERSION-x86_64-unknown-linux-gnu/bat" ~/.local/bin/
rm -r "bat-v$VERSION-x86_64-unknown-linux-gnu.tar.gz" "bat-v$VERSION-x86_64-unknown-linux-gnu" 
