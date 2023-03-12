BREW_PREFIX=$(brew --prefix)

# >>> conda initialize >>>
if [ -f "$BREW_PREFIX/Caskroom/miniforge/base/etc/profile.d/conda.sh" ]; then
. "$BREW_PREFIX/Caskroom/miniforge/base/etc/profile.d/conda.sh"
else
export PATH="$BREW_PREFIX/Caskroom/miniforge/base/bin:$PATH"
fi
# <<< conda initialize <<<

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

# add include/library search path for C/C++
export LIBRARY_PATH=$BREW_PREFIX/lib

# Source haskell ghc
source "$HOME/.ghcup/env"

# <<< language ends >>>

# >>> tool starts <<<
# export editor Path
export VISUAL=vim
export EDITOR="$VISUAL"

# export LLVM Path
export PATH=$PATH:$BREW_PREFIX/opt/llvm/bin

# export PKG-CONFIG Path
export PKG_CONFIG_PATH=$BREW_PREFIX/opt/opencv/lib/pkgconfig

# vcpkg env var
export VCPKG_ROOT="$HOME/vcpkg"

# export Python auto-complete
export PYTHONSTARTUP=~/.pythonrc

# zsh extensions
source $BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# <<< tool ends >>>

# disable homebrew analytics
export HOMEBREW_NO_ANALYTICS=1
