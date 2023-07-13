# a x86 brew
alias brow='arch --x86_64 /usr/local/Homebrew/bin/brew'

# docker alias
alias dockps="docker ps --format \"{{.ID}} {{.Names}}\""
alias dcbuild="docker-compose build"
alias dcup="docker-compose up"
alias dcdown="docker-compose down"

# quickly search history
alias hg='history | grep'

# prevent rlwrap from storing history
alias rlwrap="rlwrap --histsize -0"

#list available jdks
alias jdks="/usr/libexec/java_home -V"
