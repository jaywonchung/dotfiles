#!/bin/bash

set -ev

if [[ $(uname -m) = arm64 ]]; then
  cd "$HOME/.local/src/neovim"
  git pull
  git checkout stable
  make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX="$HOME/.local"
  make install
else
  # Get nvim release
  cd /tmp
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-macos.tar.gz
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
fi

# Install plugins
sh -c 'curl -fLo "$HOME/.local/share/nvim/site/autoload/plug.vim" --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
nvim -E -s -u ~/.config/nvim/init.vim +PlugInstall +qall!
