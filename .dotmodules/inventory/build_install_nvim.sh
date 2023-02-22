#!/usr/local/env bash

set -e

docker run --rm -v $HOME/.local:$HOME/.local ubuntu:18.04 bash -c "apt-get update && apt-get install -y --no-install-recommends ninja-build gettext libtool libt
ool-bin cmake g++ pkg-config unzip curl git doxygen ca-certificates && cd && git clone https://github.com/neovim/neovim.git && cd neovim && git checkout stable && make deps && m
ake CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX=$HOME/.local && make CMAKE_INSTALL_PREFIX=$HOME/.local install && chown -R $(id -u):$(id -g) $HOME/.local"

sh -c 'curl -fLo "$HOME/.local/share/nvim/site/autoload/plug.vim" --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
nvim -E -s -u ~/.config/nvim/init.vim +PlugInstall +qall!
