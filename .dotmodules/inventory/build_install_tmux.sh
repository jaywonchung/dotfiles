#!/usr/local/env bash

set -e

docker run --rm -v $HOME/.local:$HOME/.local ubuntu:18.04 bash -c \
  "apt-get update &&
   apt-get install -y --no-install-recommends curl ca-certificates libevent-dev ncurses-dev build-essential bison pkg-config &&
   cd &&
   curl -LO https://github.com/tmux/tmux/releases/download/3.3a/tmux-3.3a.tar.gz &&
   tar -zxf tmux-*.tar.gz &&
   cd tmux-*/ &&
   ./configure --prefix $HOME/.local --enable-static &&
   make -j &&
   make install &&
   chown -R $(id -u):$(id -g) $HOME/.local"
