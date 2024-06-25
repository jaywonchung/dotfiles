#!/usr/local/env bash

set -e

docker run --rm -v $HOME/.local:$HOME/.local ubuntu:18.04 bash -c \
  "apt-get update &&
   apt-get install -y --no-install-recommends ninja-build gettext cmake unzip curl build-essential git ca-certificates &&
   curl -LO https://github.com/Kitware/CMake/releases/download/v3.29.3/cmake-3.29.3-linux-x86_64.tar.gz &&
   tar -xzf cmake-3.29.3-linux-x86_64.tar.gz &&
   ln -s /cmake-3.29.3-linux-x86_64/bin/cmake /usr/local/bin/cmake &&
   cd &&
   git clone https://github.com/neovim/neovim.git &&
   cd neovim &&
   git checkout stable &&
   make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX=$HOME/.local &&
   rm -rf $HOME/local/bin/nvim $HOME/local/lib/nvim $HOME/local/share/nvim;
   make CMAKE_INSTALL_PREFIX=$HOME/.local install &&
   chown -R $(id -u):$(id -g) $HOME/.local"

sh -c 'curl -fLo "$HOME/.local/share/nvim/site/autoload/plug.vim" --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
nvim -E -s -u ~/.config/nvim/init.vim +PlugInstall +qall!
