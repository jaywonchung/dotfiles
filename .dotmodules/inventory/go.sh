#!/usr/bin/env bash

VERSION=${VERSION:-1.21.5}

cd /tmp
curl -LO "https://go.dev/dl/go$VERSION.linux-amd64.tar.gz"
tar -C "$HOME/.local" -xzf "go$VERSION.linux-amd64.tar.gz"
