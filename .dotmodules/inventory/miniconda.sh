#!/bin/bash

cd /tmp
ARCH="$(uname -m)"
curl -O "https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-$ARCH.sh"
bash "Miniconda3-latest-MacOSX-$ARCH.sh" -b -p "$HOME/.local/miniconda3"
rm "Miniconda3-latest-MacOSX-$ARCH.sh"
