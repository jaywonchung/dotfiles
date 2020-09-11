# install vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# install plugins
echo 'Install vim plugins. This will take a while.'
vim -E -s -u ~/.vimrc +PlugInstall +Helptags +qall!
