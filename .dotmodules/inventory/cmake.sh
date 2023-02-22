#!/bin/bash

cd /tmp
wget https://github.com/Kitware/CMake/releases/download/v3.22.0/cmake-3.22.0-linux-x86_64.tar.gz
tar xzf cmake-*
rsync -a cmake-*/bin "$HOME/.local"
rsync -a cmake-*/share "$HOME/.local"
rm -r cmake-*
