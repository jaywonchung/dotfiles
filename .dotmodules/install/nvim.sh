#!/bin/zsh

pprint() {
  printf "%*s\n" $(( (${#1} + $(tput cols) * 2 / 3) / 2 )) "$1"
}

installing() {
  pprint "#################################################"
  pprint "Installing $1"
  pprint "#################################################"
}

if [[ $(uname -m) = arm64 ]]; then
  # NOTE: No Apple silicon pre-build release for neovim
  installing "neovim (actually building it)"
  xcode-select --install || true
  brew install ninja libtool automake cmake pkg-config gettext curl
  mkdir -p "$HOME/.local/src"
  cd "$HOME/.local/src"
  git clone --depth=1 --branch=stable https://github.com/neovim/neovim.git
  make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX="$HOME/.local"
  make install
else
  installing "neovim"
  cd /tmp
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-macos.tar.gz
  tar xzvf nvim-macos.tar.gz
  mkdir -p ~/.local
  rsync -a nvim-macos/* ~/.local/
fi

installing "vim-plug"
sh -c 'curl -fLo "$HOME/.local/share/nvim/site/autoload/plug.vim" --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

installing "vim plugins"
~/.local/bin/nvim -E -s -u ~/.config/nvim/init.vim +PlugInstall +qall!
