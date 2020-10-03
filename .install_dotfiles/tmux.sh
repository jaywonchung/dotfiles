#!/bin/zsh

installing "TPM"
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

installing "TPM plugins"
~/.tmux/plugins/tpm/bin/install_plugins
