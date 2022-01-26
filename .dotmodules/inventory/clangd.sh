#!/bin/bash

cd /tmp
curl -LO https://github.com/clangd/clangd/releases/download/13.0.0/clangd-mac-13.0.0.zip
unzip clangd-mac-13.0.0.zip
rsync -a clangd_13.0.0/* "$HOME/.local"
rm -r clangd-mac-13.0.0.zip clangd_13.0.0
