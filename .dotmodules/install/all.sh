#!/bin/zsh

set -e

for file in "$HOME"/.dotmodules/install/*.sh 
do
  source "$file"
done
