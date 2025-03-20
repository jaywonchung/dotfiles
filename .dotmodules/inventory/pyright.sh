#!/bin/bash

if ! command -v node 2>&1 > /dev/null; then
  echo "You need to have Node installed."
  echo "Consider using NVM:"
  echo
  echo "$ bash ~/.dotmodules/inventory/nvm.sh"
  echo "$ nvm install node"
  echo "$ nvm use node"
  exit 1
fi

npm install -g pyright
