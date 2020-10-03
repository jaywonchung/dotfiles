#!/bin/zsh

installing "terminfo tmux-256color"
TERMINFO=~/.terminfo tic -x .dotfile_modules/tmux/terminfo

installing "TPM"
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

installing "TPM plugins"
~/.tmux/plugins/tpm/bin/install_plugins
