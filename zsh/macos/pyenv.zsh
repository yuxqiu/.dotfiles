# pyenv
# see https://github.com/pyenv/pyenv#set-up-your-shell-environment-for-pyenv
# must use - here because pyenv-virtualenv requires that
eval "$(pyenv init -)"

# pyenv-virtualenv
eval "$(pyenv virtualenv-init -)"

# hide pyenv-virtualenv warning
# from https://github.com/pyenv/pyenv-virtualenv/issues/135#issuecomment-712534748
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

# a shortcut to setup prompt
BASE_PROMPT=$PS1
function pyact() {
  pyenv activate "$@"; export PS1='($(pyenv version-name)) '$BASE_PROMPT
}
function pydeact(){
  pyenv deactivate "$@"; export PS1=$BASE_PROMPT;
}
