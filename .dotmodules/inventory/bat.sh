#!/bin/bash

BAT_VERSION=${BAT_VERSION:-"0.16.0"}

cd /tmp
curl -LO "https://github.com/sharkdp/bat/releases/download/v$BAT_VERSION/bat-v$BAT_VERSION-x86_64-unknown-linux-gnu.tar.gz"
tar xzvf "bat-v$BAT_VERSION-x86_64-unknown-linux-gnu.tar.gz"
cp "bat-v$BAT_VERSION-x86_64-unknown-linux-gnu/bat" ~/.local/bin/
