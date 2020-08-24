# install Vundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# install Pathogen
mkdir -p ~/.vim/autoload ~/.vim/bundle && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

# clone syntastic
git clone --depth=1 https://github.com/vim-syntastic/syntastic.git ~/.vim/bundle/vim-syntastic

# install plugins
vim -E -s -u ~/.vimrc +PluginInstall +Helptags +qall!
