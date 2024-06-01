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
JW_USERS=(jaywonchung jwnchung JWC cc)
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
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.
setopt APPEND_HISTORY            # append to history file
setopt HIST_NO_STORE             # Don't store history commands

# Zsh autosuggestion color
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'

# Do not highlight comments
FAST_HIGHLIGHT_STYLES[comment]='none'

# These characters are additionally considered as part of a word, so that they're skipped over
# by backward-word, forward-word, etc.
WORDCHARS='*?.~=!#$%^(){}<>'

# Keybindings
bindkey '^B'  backward-word      # Move the cursor backward by one word
bindkey '^F'  forward-word       # Move the cursor forward by one word
bindkey '^[#' pound-insert       # alt-#; Insert a pound at the front and execute (which does nothing)

# When command output is missing a newline, print this at the end
PROMPT_EOL_MARK='⏎'

#-------------------------------------------------------------------
# Powerlevel10k
#-------------------------------------------------------------------
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# Powerlevel9k options override p10k
POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
POWERLEVEL9K_SHORTEN_STRATEGY="Default"
POWERLEVEL9K_SHORTEN_DELIMITER=".."
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon host dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status anaconda time)

#-------------------------------------------------------------------
# Command-line tools
#-------------------------------------------------------------------
_UNAME="$(uname)"

# I like keeping things here
export PATH="$HOME/.local/bin:$PATH"

# Some shell scripts
export PATH="$HOME/.dotmodules/bin:$PATH"

# Launch and detach from terminal
function launch {
    nohup "$@" >/dev/null 2>/dev/null &
    disown
}

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# autojump
[[ -s "$HOME/.autojump/etc/profile.d/autojump.sh" ]] &&
    source "$HOME/.autojump/etc/profile.d/autojump.sh"

# Homebrew for MacOS
if [[ "$_UNAME" == "Darwin" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# direnv
eval "$(direnv hook zsh)"

# node
export PATH="$HOME/.local/src/node/bin:$PATH"

# eza
if command -v eza 1>/dev/null 2>/dev/null; then
  __eza_params=('--git' '--icons' '--classify' '--group-directories-first' '--time-style=long-iso' '--group' '--color-scale')
  alias ls='eza $__eza_params'
  alias l='eza --all --header --long $__eza_params'
  alias ll='eza --header --long $__eza_params'
  alias tree='eza --tree $__eza_params'
fi

#-------------------------------------------------------------------
# Language-specific
#-------------------------------------------------------------------
# Python (miniconda3)
# On CloudLab, conda init is done in /etc/zsh/zshenv
# See https://github.com/jaywonchung/ngpus-profile
if [[ ! "$(hostname)" =~ "cloudlab" ]]; then
  __conda_setup="$("$HOME/.local/miniconda3/bin/conda" 'shell.zsh' 'hook' 2> /dev/null)"
  if [ $? -eq 0 ]; then
      eval "$__conda_setup"
  else
      if [ -f "$HOME/.local/miniconda3/etc/profile.d/conda.sh" ]; then
          . "$HOME/.local/miniconda3/etc/profile.d/conda.sh"
      else
          export PATH="$HOME/.local/miniconda3/bin:$PATH"
      fi
  fi
  unset __conda_setup
fi
# Makes sure orders in PATH are consistent when sourcing .zshrc again on tmux start, etc.
export PATH="$HOME/.local/miniconda3/bin:$PATH"

# Go
export PATH="$HOME/.local/go/bin:$HOME/go/bin:$PATH"

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

# Ask for confirmation when I'm about to overwrite some file.
alias cp='cp -i'
alias mv='mv -i'

# mkdir then cd
function mkcd() {
  mkdir -p $1
  cd $1
}

# Block until a specific process finishes
function waitpid() {
  tail --pid $1 -f /dev/null
}

# Automatically reset cursor shape
function rc() {
  print -n '\033[5 q'
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

#-------------------------------------------------------------------
# Machine-specific
#-------------------------------------------------------------------
# MacOS
if [[ "$_UNAME" == "Darwin" ]]; then
  # Synctex + Neovim
  # Requires dbus. See vimtex docs section vimtex-faq-zathura-macos.
  export NVIM_LISTEN_ADDRESS=/tmp/nvimsocket
  export DBUS_SESSION_BUS_ADDRESS="unix:path=$DBUS_LAUNCHD_SESSION_BUS_SOCKET"

  # Kitty
  export PATH="/Applications/kitty.app/Contents/MacOS:$PATH"

  # Kitty ssh
  function kssh {
    kitty +kitten ssh $@
  }

  # Chrome
  export PATH="/Applications/Google Chrome.app/Contents/MacOS:$PATH"
  alias chrome="Google Chrome"

  # Sioyek
  export PATH="/Applications/sioyek.app/Contents/MacOS:$PATH"

# Linux
elif [[ "$_UNAME" == "Linux" ]]; then
  # Actually not much for now.
fi

unset _UNAME
