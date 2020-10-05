#!/bin/zsh

alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'  # later done in .zshrc
dotfiles config --local status.showUntrackedFiles no  # settings kept in .dotfiles/config
dotfiles config --local remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'  # track other branches too
dotfiles config --local diff.tool nvim  # use neovim as difftool
dotfiles config --local difftool.nvim.cmd 'nvim -d $LOCAL $REMOTE'  # use neovim as difftool
