#!/bin/bash

cd /tmp
curl -O "https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh"
bash "Miniconda3-latest-MacOSX-x86_64.sh" -b -p "$HOME/.local/miniconda3"
rm "Miniconda3-latest-MacOSX-x86_64.sh"
