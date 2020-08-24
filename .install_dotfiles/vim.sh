# install Vundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# clone syntastic
git clone --depth=1 https://github.com/vim-syntastic/syntastic.git ~/.vim/bundle/vim-syntastic

# install plugins
echo 'Install vim plugins. This will take a while.'
vim -E -s -u ~/.vimrc +PluginInstall +Helptags +qall!
