#!/bin/bash

# Anaconda distributions: https://www.anaconda.com/products/individual

VERSION=${VERSION:-2020.11}

cd /tmp
curl -O "https://repo.anaconda.com/archive/Anaconda3-$VERSION-MacOSX-x86_64.sh"
bash "Anaconda3-$VERSION-MacOSX-x86_64.sh" -b -p "$HOME/.local/anaconda3"
