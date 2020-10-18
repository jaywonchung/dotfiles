#!/bin/zsh

installing "neovim"
cd /tmp
curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz
tar xzvf nvim-linux64.tar.gz
mkdir -p ~/.local
rsync -a nvim-linux64/* ~/.local/

installing "vim-plug"
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

installing "vim plugins"
nvim -E -s -u ~/.config/nvim/init.vim +PlugInstall +qall!
