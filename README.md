## Linux (Fedora)

### General

1. Use `config/dnf` to restore all the installed packages.
2. Install [OpenSnitch](https://github.com/evilsocket/opensnitch)
    - [Disable Automatic Metadata Synchronizing](https://www.reddit.com/r/Fedora/comments/p10a5o/comment/j5ysqw1/)
3. Install [fcitx](https://wiki.archlinux.org/title/Fcitx)
    - Remember to set environment variables for IM modules.
4. Install niri
    - `sudo dnf copr enable yalter/niri` and `sudo dnf install niri` on Fedora.
    - Setup [xwayland-satellite](https://github.com/YaLTeR/niri/wiki/Xwayland) and [gtk file picker](https://github.com/YaLTeR/niri/wiki/Important-Software#portals).
5. Use `config/flatpak` to restore all the flatpak apps.
6. Stop abrt \[Optional\].
    1. [Disbale auto-reporting](https://wiki.centos.org/TipsAndTricks(2f)ABRT.html).
    2. Disbale abrt related service: [1](https://unix.stackexchange.com/questions/556351/what-are-the-risks-for-disable-the-abrtd-service) and [2](https://robbinespu.gitlab.io/posts/disable-abrt-fedora/).
7. Themes
    - Make sure `gnome-themes-extra` is installed.
    - Use [nwg-look](https://github.com/nwg-piotr/nwg-look) to adjust the theme for gtk apps.
    - You might also need to copy `~/.config/gtk-3.0` to `~/.config/gtk-4.0`.
    - For qt apps, follow the settings [here](https://unix.stackexchange.com/questions/502722/dolphin-background-and-font-color-are-both-white/683366#683366).
8. SDDM
    - Use [catppuccin/sddm](https://github.com/catppuccin/sddm) theme.
    - Follow the [Arch SDDM guide](https://wiki.archlinux.org/title/SDDM) to setup SDDM Theme.
9. Run `setup.sh` to setup the configuration files.

### DoH

1. Install dnscrypt-proxy.
    - https://wiki.archlinux.org/title/Dnscrypt-proxy details how to configure dnscrypt-proxy.
2. Disable and Stop `systemd-resolved` by following [this guide](https://askubuntu.com/questions/907246/how-to-disable-systemd-resolved-in-ubuntu).

### Others

1. vim-plug: Follow the instruction [here](https://github.com/junegunn/vim-plug).
2. rustup: Install [rustup](https://www.rust-lang.org/tools/install).
3. stew: Install [stew](https://github.com/marwanhawari/stew?tab=readme-ov-file).
    - Install binaries managed by `stew` using `Stewfile`.
4. Nerd Dictation: Follow the [installation guide](https://github.com/ideasman42/nerd-dictation) to install `vosk` and `dotool`.
5. Howdy: Follow the [guide](https://github.com/boltgolt/howdy/issues/1004) to install `howdy-beta` and configure PAM.
    - To test `howdy`, you might need to run `sudo -E howdy test` rather than `sudo howdy test`.
        - The same applies to adding face model.
6. firejail: Install and Enable `firejail` following the instructions in [ArchWiki](https://wiki.archlinux.org/title/Firejail).

### Know Issues

1. Flatpak
    - [Give filesystem access](https://davejansen.com/give-full-filesystem-access-to-flatpak-installed-applications/): use Foliate
    - Apply Theme: [how](https://itsfoss.com/flatpak-app-apply-theme/) and [theme name](https://unix.stackexchange.com/questions/14129/gtk-enable-set-dark-theme-on-a-per-application-basis)
2. Others
    - `wlroot`
        - no displaylink support: [issue](https://gitlab.freedesktop.org/wlroots/wlroots/-/issues/1823)
        - no individual window sharing support: [issue](https://github.com/emersion/xdg-desktop-portal-wlr/issues/107)
    - `systemd-resolved`
        - no DoH support: [issue](https://github.com/systemd/systemd/issues/8639)

### Keyboard

1. [How to connect Solfe via bluetooth (BT_CLR)](https://www.reddit.com/r/ErgoMechKeyboards/comments/1j4k8gy/my_nicenano_sofle_wont_connect_via_bluetooth/).
2. [Connect LogiTech K380 keyboard via `bluetoothctl`](https://unix.stackexchange.com/questions/590221/pairing-logitech-k380-in-ubuntu-20-04)

### Notes

1. I have problems connecting to my mouse via BlueTooth sometimes. I follow this [guide](https://discussion.fedoraproject.org/t/bluetooth-device-not-connecting-fedora-40/125138/18) to solve the issue.

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