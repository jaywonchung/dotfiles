#!/usr/local/env bash

set -e

docker run --rm -u $(id -u) -v $HOME/.local/src/neovim:/workspace/neovim -v $HOME/.local:$HOME/.local jw-neovim:latest bash -c "cd /workspace/neovim; git checkout stable; make distclean; make deps; make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX=$HOME/.local && make CMAKE_INSTALL_PREFIX=$HOME/.local install"
