#!/usr/bin/env bash

set -e

cd /tmp
curl -LO https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip

mkdir -p JetBrainsMono
unzip -d JetBrainsMono JetBrainsMono.zip
cd JetBrainsMono

find . -name '*NL*' -delete
find . -name '*Windows*' -delete
find . -name '*Complete.ttf' -delete
rm readme.md

mv -f *.ttf ~/Library/Fonts/
cd ..
rm -r JetBrainsMono*
