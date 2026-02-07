#!/usr/bin/env zsh

pprint() {
  printf "%*s\n" $(( (${#1} + $(tput cols) * 2 / 3) / 2 )) "$1"
}

installing() {
  pprint "#################################################"
  pprint "Installing $1"
  pprint "#################################################"
}

installing "neovim"
source ~/.dotmodules/inventory/nvim.sh
