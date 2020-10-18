# Dotfiles

## Installing dotfiles on a new system

Initialize the dotfile management environment.

```bash
git clone --bare git@github.com:jaywonchung/dotfiles.git $HOME/.dotfiles
git --git-dir=$HOME/.dotfiles --work-tree=$HOME checkout master
source .dotmodules/init.sh
```

Then checkout the desired system branch. For example, install the `ubuntu-server` settings with:

```bash
dotfiles checkout ubuntu-server
```

You may run into errors when checking out a branch due to existing dotfiles in your home directory.
Do a quick backup to a separate directory, or just remove them.

Finally, run the installation script.
```bash
zsh ~/.dotmodules/install/all.sh
```

Restarting the shell will finish the installation.

**Warning.** Don't forget to change `.gitconfig` to reflect your identity (use the `git config` command).

## Modifying configurations

In your home directory, you can do things like:

```bash
dotfiles status
dotfiles add .new_dotfile
dotfiles commit -m "A new dotfile that's really damn.. new!"
dotfiles push
```
