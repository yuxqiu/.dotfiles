# see https://stackoverflow.com/questions/37209913/how-does-alias-sudo-sudo-work
alias sudo='sudo '

# docker alias
alias dockps="docker ps --format \"{{.ID}} {{.Names}}\""
alias docklsc="docker ps -a"
alias dockrmc="docker rm"
alias docklsi="docker images -a"
alias dockrmi="docker rmi"

# docker compose
alias dcbuild="docker-compose build"
alias dcup="docker-compose up"
alias dcdown="docker-compose down"
