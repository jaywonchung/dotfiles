#!/bin/bash

CONDA_PREFIX="${CONDA_PREFIX:-$HOME/.local/miniconda3}"

cd /tmp
curl -O "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
bash "Miniconda3-latest-Linux-x86_64.sh" -b -p "$CONDA_PREFIX"
rm "Miniconda3-latest-Linux-x86_64.sh"
