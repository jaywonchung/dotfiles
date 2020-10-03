#!/bin/zsh

installing "neovim"
curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-macos.tar.gz
tar xzvf nvim-macos.tar.gz
mkdir -p ~/.local
rsync -a nvim-macos/* ~/.local/
rm -rf nvim-macos

installing "vim-plug"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

installing "vim plugins"
vim -E -s -u ~/.vimrc +PlugInstall +qall!
