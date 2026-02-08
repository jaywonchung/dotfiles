#!/bin/bash

set -ev

VERSION=${VERSION:-stable}

unamestr="$(uname)"
if [[ "$unamestr" == "Darwin" ]]; then
  OS=macos-arm64
elif [[ "$unamestr" == "Linux" ]]; then
  OS=linux-x86_64
fi

# Get nvim release
cd /tmp
curl -LO https://github.com/neovim/neovim/releases/download/$VERSION/nvim-$OS.tar.gz
xattr -c nvim-$OS.tar.gz || true
tar xzf nvim-$OS.tar.gz
mkdir -p ~/.local

# Remove
rm -f ~/.local/bin/nvim    || true
rm -rf ~/.local/lib/nvim   || true
rm -rf ~/.local/share/nvim || true

# Install nvim
rsync -a nvim-$OS/* ~/.local/

# Cleanup
rm -rf nvim-$OS

# Install tree-sitter CLI
if [[ "$unamestr" == "Darwin" ]]; then
  curl -LO https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-macos-arm64.gz
  mv tree-sitter-macos-arm64.gz tree-sitter.gz
elif [[ "$unamestr" == "Linux" ]]; then
  curl -LO https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-x64.gz
  mv tree-sitter-linux-x64.gz tree-sitter.gz
fi

gunzip tree-sitter.gz
chmod +x tree-sitter
mv -f tree-sitter ~/.local/bin/tree-sitter

# Check GLIBC version
tree-sitter --version
if [[ "$?" -ne 0 ]]; then
  echo "Error: tree-sitter CLI doesn't seem to be working. Please check if your GLIBC version is compatible."
  echo
  echo "Consider compiling from source: cargo install --locked tree-sitter-cli"
  echo "If you don't have libclang build might fail. Then consider sudo dnf install clang-devel temporarily for building."
fi
