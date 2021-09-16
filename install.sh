git clone --bare https://github.com/jaywonchung/dotfiles.git $HOME/.dotfiles
git --git-dir=$HOME/.dotfiles --work-tree=$HOME checkout master
source .dotmodules/init.sh

dotfiles checkout ubuntu-server
zsh $HOME/.dotmodules/install/all.sh
