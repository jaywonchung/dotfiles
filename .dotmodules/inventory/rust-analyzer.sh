#!/bin/bash

cd /tmp
curl -LO https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-unknown-linux-gnu.gz
gzip -d rust-analyzer-x86_64-unknown-linux-gnu.gz
mv rust-analyzer-x86_64-unknown-linux-gnu rust-analyzer
chmod +x rust-analyzer
mv rust-analyzer ~/.local/bin
rm rust-analyzer-x86_64-unknown-linux-gnu.gz
