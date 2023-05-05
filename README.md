# How to configure env

## General

0. Run `xcode-select install`
1. Clone this repository
2. Install brew and restore all softwares via bundle
    - First, install native brew
    - (Optional): if using M1 Mac, can use `arch --x86_64 /bin/zsh` to run a x86 shell and install a x86 brew.
        This is required if you want to install x86 Python via `pyenv`.
3. Install oh-my-zsh
4. Symlinks all the stuff by using stow: `stow [file]`
5. Install other dependencies as listed below

## brew 

0. To export, run `brew bundle dump`
1. Run `brew bundle --file ./config/Brewfile` to restore the installed formula

## pyenv

1. Install `pyenv` and `pyenv-virtualenv` via `brew`
2. To install x86 python, run `arch --x86_64 /bin/zsh` and  run `pyenv install [version]`
    - I personally will install a Python 3.7
    - After installation, we could use it as normal

## ssh

0. `ssh` configs are all stored in `~/.ssh`
1. After configuring env, move your 1)`known_hosts`, 2)private/public keys, and 3)`config` to the new env

## npm

0. To export, run `npm list --global --parseable --depth=0 | sed '1d' | awk '{gsub(/\/.*\//,"",$1); print}' > path/to/npmfile`
1. To import, run `xargs npm install --global < path/to/npmfile`
2. See [Export import npm global packages](https://stackoverflow.com/a/41199625)

## gpg

0. If you use gpg to sign commits, you can export it via `gpg --export-secret-key -a [email] > private.asc`
1. To import, run `gpg --import private.asc`
