#!/bin/bash

LLVM_DIR="${1-$HOME/.local/src}"

# Install LLVM
mkdir -p "$LLVM_DIR"
cd "$LLVM_DIR"
curl -LO https://github.com/llvm/llvm-project/releases/download/llvmorg-13.0.0/clang+llvm-13.0.0-x86_64-linux-gnu-ubuntu-20.04.tar.xz
tar xf clang+llvm-13.0.0-x86_64-linux-gnu-ubuntu-20.04.tar.xz
rm clang+llvm-13.0.0-x86_64-linux-gnu-ubuntu-20.04.tar.xz
mv clang+llvm-13.0.0-x86_64-linux-gnu-ubuntu-20.04 clang+llvm-13.0.0

echo LLVM installed in "$LLVM_DIR/clang+llvm-13.0.0".
