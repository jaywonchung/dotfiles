#!/bin/zsh

pprint() {
  printf "%*s\n" $(( (${#1} + $(tput cols) * 2 / 3) / 2 )) "$1"
}

installing() {
  pprint "#################################################"
  pprint "Installing $1"
  pprint "#################################################"
}

installing "Rust"
curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh

installing "ripgrep"
cargo install ripgrep

installing "fd"
cargo install fd-find
