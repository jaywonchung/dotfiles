#!/bin/bash

set -ev

cd /tmp
curl -LO https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
tar xzf install-tl-unx.tar.gz
./install-tl-*/install-tl
rm install-tl-unx.tar.gz
rm -r install-tl-*
