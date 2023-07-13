# setup different environment variables for different shells
if [[ $(arch) != arm64* ]]
then
    eval "$(/usr/local/bin/brew shellenv)"
else
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Which plugins would you like to load?
plugins=(git colored-man-pages z dirhistory macos)

# Needed to bootstrap the following source statements
DOTFILES="$HOME/.dotfiles"

source "$DOTFILES/zsh/alias.zsh"
source "$DOTFILES/zsh/env.zsh"
source "$DOTFILES/zsh/functions.zsh"

source "$ZSH/oh-my-zsh.sh"

# enable haskell ghc
source "$HOME/.ghcup/env"

# zsh extensions
source "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# On purpose because pyenv uses $PS1
# which is only fully initialized after oh-my-zsh
# So, for simplicity sake, all pyenv related stuff
# are grouped together
source "$DOTFILES/zsh/pyenv.zsh"
