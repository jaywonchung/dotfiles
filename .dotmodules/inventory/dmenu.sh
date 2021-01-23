#!/bin/bash

# This script hasn't been tested yet.

set -ev

SOURCE_DIR="$HOME/.local/src/dmenu"

# Get source
if [ ! -d "$SOURCE_DIR" ]; then
  curl http://dl.suckless.org/tools/dmenu-5.0.tar.gz
  tar xzvf dmenu-5.0.tar.gz -C "$SOURCE_DIR"
  rm dmenu-5.0.tar.gz
fi

cd "$SOURCE_DIR"
make
sudo make install
