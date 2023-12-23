#!/usr/bin/env bash

unamestr="$(uname)"
if [[ "$unamestr" == "Darwin" ]]; then
  OS=MacOSX
elif [[ "$unamestr" == "Linux" ]]; then
  OS=Linux
fi
ARCH="$(uname -m)"

cd /tmp
curl -O "https://repo.anaconda.com/miniconda/Miniconda3-latest-$OS-$ARCH.sh"
bash "Miniconda3-latest-$OS-$ARCH.sh" -b -p "$HOME/.local/miniconda3"
rm "Miniconda3-latest-$OS-$ARCH.sh"
