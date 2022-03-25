#!/bin/bash

mkdir -p "$HOME/.local/bin"

cd /tmp
wget https://github.com/latex-lsp/texlab/releases/latest/download/texlab-x86_64-macos.tar.gz
tar xzf texlab-x86_64-macos.tar.gz
rm texlab-x86_64-macos.tar.gz
mv texlab "$HOME/.local/bin"
