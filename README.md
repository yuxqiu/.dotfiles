# How to configure env

## General

### ssh

0. `ssh` configs are all stored in `~/.ssh`
1. After configuring env, move your 1)`known_hosts`, 2)private/public keys, and 3)`config` to the new env

### npm

0. To export, run `npm list --global --parseable --depth=0 | sed '1d' | awk '{gsub(/\/.*\//,"",$1); print}' > path/to/npmfile`
1. To import, run `xargs npm install --global < path/to/npmfile`
2. See [Export import npm global packages](https://stackoverflow.com/a/41199625)

### tectonic

1. [https://github.com/tectonic-typesetting/tectonic](https://github.com/tectonic-typesetting/tectonic). If possible, install it via package manager.
2. Otherwise, follow the instructions [here](https://tectonic-typesetting.github.io/book/latest/howto/build-tectonic/index.html) for custom build.

### vim-plug

1. Follow the instruction [here](https://github.com/junegunn/vim-plug).

### rustup

1. Install [rustup](https://www.rust-lang.org/tools/install).


## Linux (Fedora + KDE)

### General

0. Install [this icon theme](https://github.com/vinceliuice/Tela-circle-icon-theme) and follow [this guide](https://www.maketecheasier.com/use-custom-tray-icons-in-kde/) to add [Orchis-dark's icons](https://github.com/vinceliuice/Orchis-kde) to breeze dark.
1. Use `dnf.lst` to restore all the packages installed via `dnf`.
2. Setup [bismuth](https://github.com/Bismuth-Forge/bismuth).
3. Install [OpenSnitch](https://github.com/evilsocket/opensnitch).
    - [Disable NetworkManager Connectivity Check](https://www.reddit.com/r/Fedora/comments/6jk62f/how_can_i_stop_fedora_from_contacting/).
    - [Disable Automatic Metadata Synchronizing](https://www.reddit.com/r/Fedora/comments/p10a5o/comment/j5ysqw1/)


## MAC

### General

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

### brew

0. To export, run `brew bundle dump`
1. Turn analytics off `brew analytics off`
2. Run `brew bundle --file ./config/Brewfile` to restore the installed formula
3. For the following tasks, we need to run some scripts manually
    - `Java`: follow the instruction [here](https://formulae.brew.sh/formula/openjdk@17)

### pyenv

1. To install x86 Python, run `arch --x86_64 /bin/zsh` and `pyenv install [version]`
    - (Optional): install a Python 3.7