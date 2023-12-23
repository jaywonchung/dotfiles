#!/usr/bin/env bash

cd /tmp
curl -LO https://go.dev/dl/go1.21.5.linux-amd64.tar.gz
tar -C $HOME/.local -xzf go1.21.5.linux-amd64.tar.gz
