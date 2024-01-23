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


## Linux (Fedora)

### General

1. Use `dnf.lst` to restore all the packages installed via `dnf`.
2. Install [OpenSnitch](https://github.com/evilsocket/opensnitch).
    - [Disable NetworkManager Connectivity Check](https://www.reddit.com/r/Fedora/comments/6jk62f/how_can_i_stop_fedora_from_contacting/).
    - [Disable Automatic Metadata Synchronizing](https://www.reddit.com/r/Fedora/comments/p10a5o/comment/j5ysqw1/).
3. Install [fcitx](https://wiki.archlinux.org/title/Fcitx).
    - Remember to setup environment variables.
4. Install sway-related stuffs
    - `sudo dnf groupinstall "Sway Desktop"` on Fedora
    - `wofi/.config/wofi/launch` is derived from [reddit](https://www.reddit.com/r/swaywm/comments/krd0sq/comment/gib6z73/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button)
    - `sway/.config/sway/autotiling` is derived from [autotiling](https://github.com/nwg-piotr/autotiling)
5. Use `flatpaks.txt` to [restore](https://www.reddit.com/r/linux/comments/u3wcm7/easy_flatpak_apps_backupinstallation/) all the flatpak apps.
    - For some apps (Foliate), you might need to [give them filesystem access](https://davejansen.com/give-full-filesystem-access-to-flatpak-installed-applications/).
    - Also, we need to adjust some global settings to ensure themes are correctly applied: [how](https://itsfoss.com/flatpak-app-apply-theme/) and [theme name](https://unix.stackexchange.com/questions/14129/gtk-enable-set-dark-theme-on-a-per-application-basis)
6. Themes
    - Make sure `gnome-themes-extra` is installed.
    - Use [nwg-look](https://github.com/nwg-piotr/nwg-look) to adjust the theme for gtk apps.
    - You might also need to copy `~/.config/gtk-3.0` to `~/.config/gtk-4.0`
    - For qt apps, follow the settings [here](https://unix.stackexchange.com/questions/502722/dolphin-background-and-font-color-are-both-white/683366#683366)
7. Dolphin
    - It might not open when "show in folder" or similar functionality is used in browser and vscode. The fix is [here](https://www.reddit.com/r/hyprland/comments/18ds4gd/dolphinfile_manager_does_not_open_when_show_in/).


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