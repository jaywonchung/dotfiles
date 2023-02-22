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
# A kind reminder for others using my dotfiles
JW_USERS=(jaywonchung jwnchung JWC)
if [[ ! "${JW_USERS[*]}" =~ "$USER" ]]; then
  # Username is not Jae-Won's
  if [[ "$(git config --global --get user.name)" = "Jae-Won Chung" ]]; then
    # But git username is Jae-Won
    echo Hey, $USER. Remember to run git config with your idendity!
    echo   git config --global user.name \[YOUR NAME HERE\]
    echo   git config --global user.email \[YOUR GITHUB EMAIL HERE\]
  fi
fi
unset JW_USERS

# Path to oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Name of theme to load
ZSH_THEME=powerlevel10k/powerlevel10k

# Hyphen-insensitive completion
HYPHEN_INSENSITIVE="true"

# Update without asking me
DISABLE_UPDATE_PROMPT="true"

# Oh-my-zsh plugins
plugins=(git fast-syntax-highlighting zsh-autosuggestions docker)

# Disable completion script permission check
ZSH_DISABLE_COMPFIX="true"

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
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon host dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status virtualenv anaconda time)

#-------------------------------------------------------------------
# Command-line tools
#-------------------------------------------------------------------
# I like keeping things here
export PATH="$HOME/.local/bin:$PATH"

# Some shell scripts
export PATH="$HOME/.dotmodules/bin:$PATH"

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
# Python
# On CloudLab, conda init is done in /etc/zsh/zshenv
# See https://github.com/jaywonchung/ngpus-profile
if [[ ! "$(hostname)" =~ "cloudlab" ]]; then
  CONDA_PREFIX="$HOME/.local/miniconda3"
  __conda_setup="$("$CONDA_PREFIX/bin/conda" 'shell.zsh' 'hook' 2> /dev/null)"
  if [ $? -eq 0 ]; then
      eval "$__conda_setup"
  else
      if [ -f "$CONDA_PREFIX/etc/profile.d/conda.sh" ]; then
          . "$CONDA_PREFIX/etc/profile.d/conda.sh"
      else
          export PATH="$CONDA_PREFIX/bin:$PATH"
      fi
  fi
  unset __conda_setup
fi

# Go
export PATH="$HOME/.local/go/bin:$HOME/go/bin:$PATH"
export LD_LIBRARY_PATH="HOME/.local/go/lib:$LD_LIBRARY_PATH"

#-------------------------------------------------------------------
# Aliases
#-------------------------------------------------------------------
# git
alias gcm='git commit -m'
alias gdf='git difftool'

# dotfile management
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias dst='dotfiles status'
alias da='dotfiles add'
alias dcm='dotfiles commit -m'
alias dco='dotfiles checkout'
alias dp='dotfiles push'
alias dl='dotfiles pull'
alias ddf='dotfiles difftool'

# nvim
alias nconf="nvim $HOME/.config/nvim/init.vim"

# Ask confirmation when I'm about to overwrite some file.
alias cp='cp -i'
alias mv='mv -i'

# mkdir then cd
function mkcd() {
  mkdir -p $1
  cd $1
}

# Wait for a process to finish
function waitpid() {
  tail --pid $1 -f /dev/null
}

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

# LLVM
export PATH="$HOME/.local/src/clang+llvm-13.0.0/bin:$PATH"
export LD_LIBRARY_PATH="$HOME/.local/src/clang+llvm-13.0.0/lib:$LD_LIBRARY_PATH"
