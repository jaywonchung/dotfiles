#!/bin/bash

set -ev

SOURCE_DIR="$HOME/builds/neovim"
INSTALL_DIR="$HOME/neovim"

# Clone
if [ ! -d "$SOURCE_DIR" ]; then
  git clone https://github.com/neovim/neovim.git "$SOURCE_DIR"
fi

cd "$SOURCE_DIR"

git pull

# Build
rm -rf "$INSTALL_DIR"
make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX="$INSTALL_DIR"
make install

# Remove
bash remove_nvim.sh || true

# Install
mkdir -p "$HOME/.local"
rsync -a $INSTALL_DIR/* "$HOME/.local/"
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
nvim -E -s -u ~/.config/nvim/init.vim +PlugInstall +qall!
