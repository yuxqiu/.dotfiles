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
5. Install [warpd](https://github.com/rvaiya/warpd/) \[Optional\]
6. Use `flatpaks.txt` to [restore](https://www.reddit.com/r/linux/comments/u3wcm7/easy_flatpak_apps_backupinstallation/) all the flatpak apps.
7. Stop abrt \[Optional\]
    1. Disbale auto-reporting: https://wiki.centos.org/TipsAndTricks(2f)ABRT.html
    2. Disbale abrt related service: https://unix.stackexchange.com/questions/556351/what-are-the-risks-for-disable-the-abrtd-service and https://robbinespu.gitlab.io/posts/disable-abrt-fedora/
8. Themes
    - Make sure `gnome-themes-extra` is installed.
    - Use [nwg-look](https://github.com/nwg-piotr/nwg-look) to adjust the theme for gtk apps.
    - You might also need to copy `~/.config/gtk-3.0` to `~/.config/gtk-4.0`
    - For qt apps, follow the settings [here](https://unix.stackexchange.com/questions/502722/dolphin-background-and-font-color-are-both-white/683366#683366)


### Know Issues

1. Flatpak
    - [Give filesystem access](https://davejansen.com/give-full-filesystem-access-to-flatpak-installed-applications/): use Foliate
    - Apply Theme: [how](https://itsfoss.com/flatpak-app-apply-theme/) and [theme name](https://unix.stackexchange.com/questions/14129/gtk-enable-set-dark-theme-on-a-per-application-basis)
2. [Implement org.freedesktop.portal.OpenURI](https://github.com/emersion/xdg-desktop-portal-wlr/issues/42)
    - `xdg-desktop-portal-wlr` does not support `OpenURI`.
    - If you are using `sway`, install `xdg-desktop-portal-gtk` directly as in `/usr/share/xdg-desktop-portal/sway-portals.conf`, default is set to use `gtk` backend (for most of the interfaces).
3. Tracking Issues
    - `wlroot`
        - no displaylink support: [issue](https://gitlab.freedesktop.org/wlroots/wlroots/-/issues/1823)
        - no individual window sharing support: [issue](https://github.com/emersion/xdg-desktop-portal-wlr/issues/107)
    - `vscode`
        - no IME support under wayland: [issue](https://github.com/microsoft/vscode/issues/167757)
    - `Obsidian`
        - When running on wayland, IME does not work. Passing `enable-wayland-ime` does not work -> Run on XWayland
    - `sway`
        - IME popup support: [background](https://wiki.archlinux.org/title/Fcitx5#Sway) and [pr](https://github.com/swaywm/sway/pull/7226) (merged, but not released)
        - ICC profile support: [pr](https://github.com/swaywm/sway/issues/1486)(merged, but not released)
4. NetworkManager
    - no way to randomize hostname: [issue](https://gitlab.freedesktop.org/NetworkManager/NetworkManager/-/issues/584)


### Notes

1. `sway/.config/sway/inputs` is marked to ignore future updates as I want to keep the data in it private.
    - [How to mark/unmark it](https://stackoverflow.com/questions/4348590/how-can-i-make-git-ignore-future-revisions-to-a-file)
2. I have problems connecting to my mouse via BlueTooth sometimes. I follow this [guide](https://discussion.fedoraproject.org/t/bluetooth-device-not-connecting-fedora-40/125138/18) to solve the issue.


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