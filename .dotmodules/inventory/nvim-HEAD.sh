#!/bin/bash

set -ev

SOURCE_DIR="$HOME/builds/neovim"
INSTALL_DIR="$HOME/neovim"

# Get source
if [ ! -d "$SOURCE_DIR" ]; then
  git clone https://github.com/neovim/neovim.git "$SOURCE_DIR"
fi
cd "$SOURCE_DIR"
git pull

# Build
rm -rf "$INSTALL_DIR" || true
make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX="$INSTALL_DIR"
make install
mkdir -p "$HOME/.local"

# Remove existing installation
rm -f ~/.local/bin/nvim    || true
rm -rf ~/.local/lib/nvim   || true
rm -rf ~/.local/share/nvim || true

# Install
rsync -a $INSTALL_DIR/* "$HOME/.local/"

# Install plugins
sh -c 'curl -fLo "$HOME/.local/share/nvim/site/autoload/plug.vim" --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
nvim -E -s -u ~/.config/nvim/init.vim +PlugInstall +qall!

# Cleanup
rm -rf "$INSTALL_DIR"
