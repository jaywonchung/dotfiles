#!/bin/bash

LLVM_DIR="${1-$HOME/.local/src}"

# Install LLVM
mkdir -p "$LLVM_DIR"
cd "$LLVM_DIR"
curl -LO https://github.com/llvm/llvm-project/releases/download/llvmorg-13.0.0/clang+llvm-13.0.0-x86_64-linux-gnu-ubuntu-20.04.tar.xz
tar xf clang+llvm-13.0.0-x86_64-linux-gnu-ubuntu-20.04.tar.xz
rm clang+llvm-13.0.0-x86_64-linux-gnu-ubuntu-20.04.tar.xz
mv clang+llvm-13.0.0-x86_64-linux-gnu-ubuntu-20.04 clang+llvm-13.0.0
export PATH="$LLVM_DIR/clang+llvm-13.0.0/bin:$PATH"

# Build ccls
mkdir -p "$HOME/.local/src"
cd "$HOME/.local/src"
git clone --depth=1 --recursive https://github.com/MaskRay/ccls.git
cd ccls

LLVM="$(llvm-config --prefix)/lib/cmake"
cmake -H. -BRelease -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="$LLVM" -DCMAKE_INSTALL_PREFIX="$HOME/.local"
cmake --build Release
cmake --build Release --target install
