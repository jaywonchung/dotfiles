#!/bin/bash

version=${version:-3.28.1}

unamestr="$(uname)"
if [[ "$unamestr" == "Darwin" ]]; then
  cd /tmp
  wget https://github.com/Kitware/CMake/releases/download/v$version/cmake-$version-macos-universal.tar.gz
  tar xzf cmake-*
  rsync -a cmake-*/bin "$HOME/.local"
  rsync -a cmake-*/share "$HOME/.local"
  rm -r cmake-*
elif [[ "$unamestr" == "Linux" ]]; then
  cd /tmp
  wget https://github.com/Kitware/CMake/releases/download/v$version/cmake-$version-linux-x86_64.tar.gz
  tar xzf cmake-*
  rsync -a cmake-*/bin "$HOME/.local"
  rsync -a cmake-*/share "$HOME/.local"
  rm -r cmake-*
fi
