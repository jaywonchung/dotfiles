#-------------------------------------------------------------------
# Zsh and oh-my-zsh configs
#-------------------------------------------------------------------
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Name of theme to load
ZSH_THEME=powerlevel10k/powerlevel10k

# Hyphen-insensitive completion
HYPHEN_INSENSITIVE="true"

# Update without asking me
DISABLE_UPDATE_PROMPT="true"

# Oh-my-zsh plugins
plugins=(git fast-syntax-highlighting zsh-autosuggestions)

# Configure oh-my-zsh
source $ZSH/oh-my-zsh.sh

# Language environment
export LANG=en_US.UTF-8

# Enable dircolors
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
fi

# Shell options
setopt nonomatch

# Zsh autosuggestion color
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'

#-------------------------------------------------------------------
# Powerlevel10k
#-------------------------------------------------------------------
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# Powerlevel9k options override p10k
POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
POWERLEVEL9K_SHORTEN_STRATEGY="Default"
POWERLEVEL9K_SHORTEN_DELIMITER=".."
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon host dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status virtualenv anaconda time)

#-------------------------------------------------------------------
# Python environments
#-------------------------------------------------------------------
source "$HOME/.dotfile_modules/zshrc/python-env.sh"

#-------------------------------------------------------------------
# Command-line tools
#-------------------------------------------------------------------
# Fuzzy Finder
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Autojmp
[[ -s "$HOME/.autojump/etc/profile.d/autojump.sh" ]] &&
    source "$HOME/.autojump/etc/profile.d/autojump.sh"
autoload -U compinit && compinit -u

#-------------------------------------------------------------------
# Aliases
#-------------------------------------------------------------------
# Git
alias gcm='git commit -m'

# Managing dotfiles
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

#-------------------------------------------------------------------
# Environment variables
#-------------------------------------------------------------------
# /usr/local/lib should be in LD_LIBRARY_PATH
export LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"

# vim as manpage viewer
export MANPAGER="/bin/sh -c \"unset PAGER;col -b -x | \
    vim --noplugin -R -c 'set ft=man nomod nolist' -c 'map q :q<CR>' \
    -c 'map <SPACE> <C-D>' -c 'map b <C-U>' \
    -c 'set nonu' -c 'set nornu' \
    -c 'nmap K :Man <C-R>=expand(\\\"<cword>\\\")<CR><CR>' -\""
#-------------------------------------------------------------------
# Machine-specific
#-------------------------------------------------------------------
source "$HOME/.dotfile_modules/zshrc/machine-specific.sh"
