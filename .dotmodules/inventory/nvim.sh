#!/bin/bash

set -ev

VERSION=${2:-"v0.5.1"}

# Get nvim release
cd /tmp
curl -LO "https://github.com/neovim/neovim/releases/download/$VERSION/nvim-macos.tar.gz"
tar xzf nvim-macos.tar.gz
mkdir -p ~/.local

# Remove
rm -f ~/.local/bin/nvim    || true
rm -rf ~/.local/lib/nvim   || true
rm -rf ~/.local/share/nvim || true

# Install nvim
rsync -a nvim-osx64/* ~/.local/

# Cleanup
rm -rf nvim-osx64

# Install plugins
sh -c 'curl -fLo "$HOME/.local/share/nvim/site/autoload/plug.vim" --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
nvim -E -s -u ~/.config/nvim/init.vim +PlugInstall +qall!
