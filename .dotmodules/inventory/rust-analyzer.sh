#!/bin/bash

curl -L https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-unknown-linux-gnu.gz \
  | gzip -d - > ~/.local/bin/rust-analyzer
chmod +x ~/.local/bin/rust-analyzer
