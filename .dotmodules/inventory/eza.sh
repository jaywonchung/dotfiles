#!/bin/bash

if ! command -v cargo > /dev/null; then
  echo Cargo must be installed.
  exit 1
fi

cargo install eza
