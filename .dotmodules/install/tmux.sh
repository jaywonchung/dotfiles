#!/usr/bin/env zsh

pprint() {
  printf "%*s\n" $(( (${#1} + $(tput cols) * 2 / 3) / 2 )) "$1"
}

installing() {
  pprint "#################################################"
  pprint "Installing $1"
  pprint "#################################################"
}

rm -r $HOME/.tmux/plugins || true

installing catputtin/tmux
mkdir -p ~/.local/src/tmux/plugins/catppuccin
git clone -b v2.1.2 https://github.com/catppuccin/tmux.git ~/.local/src/tmux/plugins/catppuccin/tmux

installing jaywonchung/vim-tmux-navigator
mkdir -p ~/.local/src/tmux/plugins/jaywonchung
git clone https://github.com/jaywonchung/vim-tmux-navigator.git ~/.local/src/tmux/plugins/jaywonchung/vim-tmux-navigator
