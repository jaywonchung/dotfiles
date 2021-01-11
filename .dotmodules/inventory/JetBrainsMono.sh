#!/bin/sh

cd /tmp
curl -LJO https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
unzip JetBrainsMono.zip

FONTDIR="$HOME/.local/share/fonts"
mv "JetBrains Mono Regular Nerd Font Complete Mono.ttf" "$FONTDIR"
mv "JetBrains Mono Bold Nerd Font Complete Mono.ttf" "$FONTDIR"
mv "JetBrains Mono Italic Nerd Font Complete Mono.ttf" "$FONTDIR"
mv "JetBrains Mono Bold Italic Nerd Font Complete Mono.ttf" "$FONTDIR"

rm JetBrains*
