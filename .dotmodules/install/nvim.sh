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
unamestr="$(uname)"
if [[ "$unamestr" == "Darwin" ]]; then
  cd /tmp
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-macos-arm64.tar.gz
  tar xzvf nvim-macos-arm64.tar.gz
  mkdir -p ~/.local
  rsync -a nvim-macos-arm64/* ~/.local/
elif [[ "$unamestr" == "Linux" ]]; then
  cd /tmp
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
  tar xzvf nvim-linux-x86_64.tar.gz
  mkdir -p ~/.local
  rsync -a nvim-linux-x86_64/* ~/.local/
fi
echo "done"
