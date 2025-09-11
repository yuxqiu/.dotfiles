# A temporary workaround until zsh is managed by nix
. "/home/yuxqiu/.nix-profile/etc/profile.d/hm-session-vars.sh"

# Disable auto update and magic functions
DISABLE_AUTO_UPDATE="true"
DISABLE_MAGIC_FUNCTIONS="true"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Which plugins would you like to load?
# - ssh-agent: auto start ssh-agent
plugins=(git colored-man-pages z dirhistory ssh-agent)

# Do not load any identity on the start
zstyle :omz:plugins:ssh-agent lazy yes

# Path to oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"
source "$ZSH/oh-my-zsh.sh"

# Needed to bootstrap the following source statements
DOTFILES="$HOME/.dotfiles"

source "$DOTFILES/zsh/commons/commons.zsh"

if [ "$(uname)" = "Darwin" ]; then
    source "$DOTFILES/zsh/macos/macos.zsh"
elif [ "$(expr substr $(uname -s) 1 5)" = "Linux" ]; then
    source "$DOTFILES/zsh/linux/linux.zsh"
fi
