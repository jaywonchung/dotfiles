#!/bin/bash

# Install LLVM
brew install llvm

# Build ccls
mkdir -p "$HOME/.local/src"
cd "$HOME/.local/src"
git clone --depth=1 --recursive https://github.com/MaskRay/ccls.git
cd ccls

export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
LLVM="$(llvm-config --prefix)/lib/cmake"
cmake -H. -BRelease -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="$LLVM" -DCMAKE_INSTALL_PREFIX="$HOME/.local"
cmake --build Release
cmake --build Release --target install
