#!/bin/zsh

installing "vim-plug"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

installing "vim plugins"
vim -E -s -u ~/.vimrc +PlugInstall +qall!
