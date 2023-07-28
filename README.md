# How to configure env

## General

0. Set caps lock to escape
1. Run `xcode-select install`
2. Clone this repository
3. Install brew and restore all softwares via bundle
    - First, install native brew
    - (Optional): if using M1 Mac, can use `arch --x86_64 /bin/zsh` to run a x86 shell and install a x86 brew.
        This is required if you want to install x86 Python via `pyenv`.
4. Install oh-my-zsh
5. Install other dependencies as listed below
6. Symlinks all the stuff by using stow: `stow [file]`

## brew

0. To export, run `brew bundle dump`
1. Turn analytics off `brew analytics off`
2. Run `brew bundle --file ./config/Brewfile` to restore the installed formula

## pyenv

1. Install `pyenv` and `pyenv-virtualenv` via `brew`
2. To install x86 Python, run `arch --x86_64 /bin/zsh` and `pyenv install [version]`
    - (Optional): install a Python 3.7

## ssh

0. `ssh` configs are all stored in `~/.ssh`
1. After configuring env, move your 1)`known_hosts`, 2)private/public keys, and 3)`config` to the new env

## npm

0. To export, run `npm list --global --parseable --depth=0 | sed '1d' | awk '{gsub(/\/.*\//,"",$1); print}' > path/to/npmfile`
1. To import, run `xargs npm install --global < path/to/npmfile`
2. See [Export import npm global packages](https://stackoverflow.com/a/41199625)

## Texlive

1. Install texlive by following the instructions here:
[https://tex.stackexchange.com/questions/397174/minimal-texlive-installation](https://tex.stackexchange.com/questions/397174/minimal-texlive-installation)

## cheat.sh

1. Install `cheat.sh` by following the instructions here
[https://github.com/chubin/cheat.sh](https://github.com/chubin/cheat.sh)

## Devbox

1. Follow the instructions here
[https://www.jetpack.io/devbox/docs/installing_devbox/](https://www.jetpack.io/devbox/docs/installing_devbox/)