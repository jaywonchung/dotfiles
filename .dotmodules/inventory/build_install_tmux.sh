#!/usr/local/env bash

# The docker command didn't really work in ampere01 last time -- it kept dying with Server exited unexpectedly, and according to strace, libnss_files-2.28.so was getting a segfault.
# So I just `sudo yum install`'ed libevent-devel, ncurses-devel, and bison and compiled tmux locally on the node **without --enable-static**, and it worked.

set -e

# docker run --rm -v $HOME/.local:$HOME/.local ubuntu:18.04 bash -c \
#   "apt-get update &&
#    apt-get install -y --no-install-recommends curl ca-certificates libevent-dev ncurses-dev build-essential bison pkg-config &&
#    cd &&
#    curl -LO https://github.com/tmux/tmux/releases/download/3.4/tmux-3.4.tar.gz &&
#    tar -zxf tmux-*.tar.gz &&
#    cd tmux-*/ &&
#    ./configure --prefix $HOME/.local --enable-static &&
#    make -j &&
#    make install &&
#    chown -R $(id -u):$(id -g) $HOME/.local"

cd /tmp
curl -LO https://github.com/tmux/tmux/releases/download/3.4/tmux-3.4.tar.gz
tar -zxf tmux-*.tar.gz
cd tmux-*/
./configure --prefix $HOME/.local
make -j
make install
