#!/bin/bash

VERSION="16.0.0"

cd /tmp
curl -LO "https://github.com/valentjn/ltex-ls/releases/download/$VERSION/ltex-ls-$VERSION-mac-x64.tar.gz"
tar xf "ltex-ls-$VERSION-mac-x64.tar.gz"
rsync -a ltex-ls-$VERSION/{bin,lib,jdk-11.0.12+7} "$HOME/.local/"
rm -fr ltex-ls-$VERSION-mac-x64.tar.gz ltex-ls-$VERSION
