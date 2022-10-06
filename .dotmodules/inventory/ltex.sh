#!/bin/bash

cd /tmp
curl -LO https://github.com/valentjn/ltex-ls/releases/download/15.2.0/ltex-ls-15.2.0-mac-x64.tar.gz
tar xf ltex-ls-15.2.0-mac-x64.tar.gz
rsync -a ltex-ls-15.2.0/{bin,lin,jdk-11.0.12+7} "$HOME/.local/"
rm -r ltex-ls-15.2.0-mac-x64.tar.gz ltex-ls-15.2.0
