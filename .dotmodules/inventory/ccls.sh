#!/bin/bash

LLVM="$(llvm-config --prefix)/lib/cmake"
echo Using LLVM resource directory "$LLVM".

# Build ccls
mkdir -p "$HOME/.local/src"
cd "$HOME/.local/src"
git clone --depth=1 --recursive https://github.com/MaskRay/ccls.git
cd ccls

cmake -H. -BRelease -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="$LLVM" -DCMAKE_INSTALL_PREFIX="$HOME/.local"
cmake --build Release
cmake --build Release --target install
