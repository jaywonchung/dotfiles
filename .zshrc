#-------------------------------------------------------------------
# Powerlevel10k instant prompt
#-------------------------------------------------------------------
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#-------------------------------------------------------------------
# Zsh and oh-my-zsh configs
#-------------------------------------------------------------------
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

# Do not highlight comments
FAST_HIGHLIGHT_STYLES[comment]='none'

# Keybindings
bindkey '^B'  backward-word
bindkey '^F'  forward-word
bindkey '^[#' pound-insert  # alt-#

#-------------------------------------------------------------------
# Powerlevel10k
#-------------------------------------------------------------------
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# Powerlevel9k options override p10k
POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
POWERLEVEL9K_SHORTEN_STRATEGY="Default"
POWERLEVEL9K_SHORTEN_DELIMITER=".."
if [ -n "$NOGIT" ]; then
  POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon host dir)
else
  POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon host dir vcs)
fi
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status virtualenv anaconda time)

#-------------------------------------------------------------------
# Command-line tools
#-------------------------------------------------------------------
# I like keeping things here
export PATH="$HOME/.local/bin:$PATH"

# Some shell scripts
export PATH="$HOME/.dotmodules/bin:$PATH"

# Launch and close terminal
function launch {
    nohup "$@" >/dev/null 2>/dev/null & disown; exit
}

# SNU network is wierd
function sssh {
    ssh $1 || ssh $1
}
compdef sssh=ssh

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# autojump
[[ -s "$HOME/.autojump/etc/profile.d/autojump.sh" ]] &&
    source "$HOME/.autojump/etc/profile.d/autojump.sh"
autoload -U compinit && compinit -u

# direnv
eval "$(direnv hook zsh)"

# node
export PATH="$HOME/.local/src/node/bin:$PATH"

#-------------------------------------------------------------------
# Language-specific
#-------------------------------------------------------------------
source "$HOME/.dotmodules/zshrc/python-env.sh"

#-------------------------------------------------------------------
# Aliases
#-------------------------------------------------------------------
# git
alias gcm='git commit -m'

# dotfile management
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
compdef dotfiles=git
alias dst='dotfiles status'
alias da='dotfiles add'
alias dcm='dotfiles commit -m'
alias dco='dotfiles checkout'
alias dp='dotfiles push'
alias dl='dotfiles pull'
alias ddf='dotfiles difftool'

# nvim
alias nconf="nvim $HOME/.config/nvim/init.vim"

# add flags
alias cp='cp -i'

# mkdir then cd
alias mkcd='mkdir -p $1 && cd $1'

#-------------------------------------------------------------------
# Environment variables
#-------------------------------------------------------------------
# /usr/local/lib should be in LD_LIBRARY_PATH
export LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"

# nvim as editor
export EDITOR="nvim"

# nvim as manpage viewer
export MANPAGER="nvim +Man!"
export MANWIDTH=999

# For xdg-open
export BROWSER="naver-whale-stable"

# nvim-remote
export NVIM_LISTEN_ADDRESS="$HOME/.local/nvimsocket"
alias nvim="nvim --listen $NVIM_LISTEN_ADDRESS"

#-------------------------------------------------------------------
# Machine-specific
#-------------------------------------------------------------------
source "$HOME/.dotmodules/zshrc/machine-specific.sh"
