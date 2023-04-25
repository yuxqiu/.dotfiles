# a x86 brew
alias brow='arch --x86_64 /usr/local/Homebrew/bin/brew'

# setup different environment variables for different shells
if [[ $(arch) != arm64* ]]
then
    eval "$(/usr/local/bin/brew shellenv)"
else
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Ruby
# source $BREW_PREFIX/opt/chruby/share/chruby/chruby.sh
# source $BREW_PREFIX/opt/chruby/share/chruby/auto.sh

# Path to your oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Which plugins would you like to load?
plugins=(git colored-man-pages z dirhistory macos)

source $ZSH/oh-my-zsh.sh

# >>> alias starts <<<

# -- docker alias
alias dockps="docker ps --format \"{{.ID}} {{.Names}}\""
# ----- execute with docksh <id>
docksh(){
    docker exec -it $1 /bin/bash
}
alias dcbuild="docker-compose build"
alias dcup="docker-compose up"
alias dcdown="docker-compose down"

# -- quickly search history
alias hg='history | grep'

# -- prevent rlwrap from storing history
alias rlwrap="rlwrap --histsize -0"

# <<< alias ends >>>

# >>> function starts <<<

function pipcn() {
    python -m pip $@ -i https://pypi.tuna.tsinghua.edu.cn/simple;
}

# -- alias for x86_64
function run64() {
    arch -x86_64 $1
}

# download file and verify their checksum
function checksum() {
  s=$(curl -fsSL "$1")
  if ! command -v shasum >/dev/null
  then
    shasum() { sha1sum "$@"; }
  fi
  c=$(printf %s\\n "$s" | shasum | awk '{print $1}')
  if [ "$c" = "$2" ]
  then
    printf %s\\n "$s"
  else
    echo "invalid checksum $c != $2" 1>&2;
  fi
  unset s
  unset c
}

# <<< function ends >>>

# >>> language starts <<<

# Source haskell ghc
source "$HOME/.ghcup/env"

# <<< language ends >>>

# >>> tool starts <<<
# export editor Path
export VISUAL=vim
export EDITOR="$VISUAL"

# vcpkg env var
export VCPKG_ROOT="$HOME/vcpkg"

# export Python auto-complete
export PYTHONSTARTUP=~/.pythonrc

# zsh extensions
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# pyenv
# see https://github.com/pyenv/pyenv#set-up-your-shell-environment-for-pyenv
# must use - here because pyenv-virtualenv requires that
eval "$(pyenv init -)"

# pyenv-virtualenv
eval "$(pyenv virtualenv-init -)"

# hide pyenv-virtualenv warning
# from https://github.com/pyenv/pyenv-virtualenv/issues/135#issuecomment-712534748
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

# To install x86 python, run arch --x86_64 /bin/zsh
# Then run pyenv install [version]
# I choose not to use separate paths here
# as I only install Python <= 3.7 in x86_64
#
# After installation, you could use it as normal
# Don't need to run x86 shell

# <<< tool ends >>>

# disable homebrew analytics
export HOMEBREW_NO_ANALYTICS=1
