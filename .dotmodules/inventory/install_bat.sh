#!/bin/bash

BAT_VERSION=${BAT_VERSION:-"0.17.1"}

cd /tmp
curl -LO "https://github.com/sharkdp/bat/releases/download/v$BAT_VERSION/bat-v$BAT_VERSION-x86_64-apple-darwin.tar.gz"
tar xzvf "bat-v$BAT_VERSION-x86_64-apple-darwin.tar.gz"
cp "bat-v$BAT_VERSION-x86_64-apple-darwin/bat" ~/.local/bin/
