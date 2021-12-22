#!/bin/bash

if ! command -v brew > /dev/null; then
  echo Homebrew must be installed.
  exit 1
fi

brew install direnv
