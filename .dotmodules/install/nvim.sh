#!/bin/zsh

pprint() {
  printf "%*s\n" $(( (${#1} + $(tput cols) * 2 / 3) / 2 )) "$1"
}

installing() {
  pprint "#################################################"
  pprint "Installing $1"
  pprint "#################################################"
}

installing "neovim"
cd /tmp
curl -LO https://github.com/neovim/neovim/releases/download/v0.5.0/nvim-macos.tar.gz
tar xzvf nvim-macos.tar.gz
mkdir -p ~/.local
rsync -a nvim-macos/* ~/.local/

installing "vim-plug"
sh -c 'curl -fLo "$HOME/.local/share/nvim/site/autoload/plug.vim" --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

installing "vim plugins"
~/.local/bin/nvim -E -s -u ~/.config/nvim/init.vim +PlugInstall +qall!
