#!/bin/zsh

installing "neovim"
curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz
tar xzvf nvim-linux64.tar.gz
mkdir -p ~/.local
rsync -a nvim-linux64/* ~/.local/
rm -rf nvim-linux64

installing "vim-plug"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

installing "vim plugins"
vim -E -s -u ~/.vimrc +PlugInstall +qall!
