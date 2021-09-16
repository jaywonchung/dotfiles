git clone --bare https://github.com/jaywonchung/dotfiles.git $HOME/.dotfiles
git --git-dir=$HOME/.dotfiles --work-tree=$HOME checkout master
source .dotmodules/init.sh
