#!/bin/bash

set -ev

# Remove
bash "$HOME/.dotmodules/inventory/remove_nvim.sh" || true

# Install Neovim nightly
cd /tmp
curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz
tar xzvf nvim-linux64.tar.gz
mkdir -p ~/.local
rsync -a nvim-linux64/* ~/.local/

# Install plugins
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
nvim -E -s -u ~/.config/nvim/init.vim +PlugInstall +qall!
