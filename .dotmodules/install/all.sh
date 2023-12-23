#!/usr/bin/env zsh

unamestr="$(uname)"
# MacOS
if [[ "$unamestr" == "Darwin" ]]; then
  source ~/.dotmodules/install/brew.sh
fi

source ~/.dotmodules/install/zsh.sh
source ~/.dotmodules/install/tmux.sh
source ~/.dotmodules/install/nvim.sh
source ~/.dotmodules/install/rust.sh
