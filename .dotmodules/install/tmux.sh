#!/bin/zsh

pprint() {
  printf "%*s\n" $(( (${#1} + $(tput cols) * 2 / 3) / 2 )) "$1"
}

installing() {
  pprint "#################################################"
  pprint "Installing $1"
  pprint "#################################################"
}

installing "terminfo tmux-256color"
TERMINFO=~/.terminfo tic -x .dotmodules/tmux/terminfo

installing "TPM"
git clone --depth=1 https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

installing "TPM plugins"
~/.tmux/plugins/tpm/bin/install_plugins
