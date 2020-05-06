#!/bin/zsh

# zsh
export RUNZSH=no
export KEEP_ZSHRC=yes
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
source ~/.zshrc

# install powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"

# install fast-syntax-highlighting
git clone https://github.com/zdharma/fast-syntax-highlighting.git "$ZSH_CUSTOM/plugins/fast-syntax-highlighting"

# install zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

# install fuzzy finder
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
printf 'yyn' | ~/.fzf/install # Enable fuzzy-autocompletion and key bindings. Do not modify .zshrc.

# install autojump
git clone https://github.com/wting/autojump.git ~/_autojump
cd ~/_autojump
./install.py
rm -rf ~/_autojump
