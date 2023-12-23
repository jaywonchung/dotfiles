#!/usr/bin/env bash

version=${version:-17.0.3}

unamestr="$(uname)"
if [[ "$unamestr" == "Darwin" ]]; then
  cd /tmp
  curl -LO https://github.com/clangd/clangd/releases/download/$version/clangd-mac-$version.zip
  unzip clangd-mac-$version.zip
  rsync -a clangd_$version/* "$HOME/.local"
  rm -r clangd-mac-$version.zip clangd_$version
elif [[ "$unamestr" == "Linux" ]]; then
  cd /tmp
  curl -LO https://github.com/clangd/clangd/releases/download/$version/clangd-linux-$version.zip
  unzip clangd-linux-$version.zip
  rsync -a clangd_$version/* "$HOME/.local"
  rm -r clangd-linux-$version.zip clangd_$version
fi
