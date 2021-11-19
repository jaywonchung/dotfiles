#!/bin/zsh

pprint() {
  printf "%*s\n" $(( (${#1} + $(tput cols) * 2 / 3) / 2 )) "$1"
}

installing() {
  pprint "#################################################"
  pprint "Installing $1"
  pprint "#################################################"
}

installing "Oh-my-zsh"
export RUNZSH=no
export KEEP_ZSHRC=yes
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
source ~/.zshrc

installing "Powerlevel10k"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"

installing "fast-syntax-highlighting"
git clone --depth=1 https://github.com/zdharma-continuum/fast-syntax-highlighting.git "$ZSH_CUSTOM/plugins/fast-syntax-highlighting"

installing "zsh-autosuggestions"
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

installing "fzf"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
printf 'y\ny\nn\n' | ~/.fzf/install # Enable fuzzy-autocompletion and key bindings. Do not modify .zshrc.

installing "autojump"
git clone --depth=1 https://github.com/wting/autojump.git ~/_autojump
pushd ~/_autojump
python3 install.py
popd
rm -rf ~/_autojump

installing "direnv"
mkdir -p ~/.local/bin
curl -sfL https://direnv.net/install.sh | bin_path=~/.local/bin bash
