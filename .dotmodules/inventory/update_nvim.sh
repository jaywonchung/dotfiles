#!/bin/bash

# Remove
rm -f ~/.local/bin/nvim
rm -rf ~/.local/lib/nvim
rm -rf ~/.local/share/nvim

# Install
cd /tmp
curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-macos.tar.gz
tar xzvf nvim-macos.tar.gz
mkdir -p ~/.local
rsync -a nvim-osx64/* ~/.local/

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
nvim -E -s -u ~/.config/nvim/init.vim +PlugInstall +qall!
