# Dotfiles

## Installing dotfiles to a new system

Initialize the dotfile management environment.

```bash
git clone --bare https://github.com/jaywonchung/dotfiles.git $HOME/.dotfiles
source .install_dotfiles/init.sh
```

Then checkout the desired system branch. For example, install the `ubuntu-desktop` settings with:

```bash
dotfiles checkout ubuntu-desktop
```

You may run into errors when checking out a branch due to existing dotfiles in your home directory.
Do a quick backup to a separate directory, or just remove them.

Finally, run the post-checkout script. It installs packages.
```bash
zsh ~/.install_dotfiles/post_checkout.sh
source ~/.zshrc
```

## Modifying configurations

In your home directory, you can do things like:

```bash
dotfiles status
dotfiles add .new_dotfile
dotfiles commit -m "A new dotfile that's really damn.. new!"
dotfiles push
```
