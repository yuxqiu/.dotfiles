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
5. Stop abrt \[Optional\].
    1. [Disbale auto-reporting](https://wiki.centos.org/TipsAndTricks(2f)ABRT.html).
    2. Disbale abrt related service: [1](https://unix.stackexchange.com/questions/556351/what-are-the-risks-for-disable-the-abrtd-service) and [2](https://robbinespu.gitlab.io/posts/disable-abrt-fedora/).
6. Themes
    - Make sure `gnome-themes-extra` is installed.
    - Use [nwg-look](https://github.com/nwg-piotr/nwg-look) to adjust the theme for gtk apps.
    - You might also need to copy `~/.config/gtk-3.0` to `~/.config/gtk-4.0`.
    - For qt apps, follow the settings [here](https://unix.stackexchange.com/questions/502722/dolphin-background-and-font-color-are-both-white/683366#683366).
7. SDDM
    - Use [catppuccin/sddm](https://github.com/catppuccin/sddm) theme.
    - Follow the [Arch SDDM guide](https://wiki.archlinux.org/title/SDDM) to setup SDDM Theme.
8. Run `setup.sh` to setup the configuration files.

### DoH

1. Disable and stop `systemd-resolved` by following [this guide](https://askubuntu.com/questions/907246/how-to-disable-systemd-resolved-in-ubuntu).

### Others

1. rustup: Install [rustup](https://www.rust-lang.org/tools/install).
2. Nerd Dictation: Follow the [installation guide](https://github.com/ideasman42/nerd-dictation) to install `vosk` and `dotool`.
3. Howdy: Follow the [guide](https://github.com/boltgolt/howdy/issues/1004) to install `howdy-beta` and configure PAM.
    - To test `howdy`, you might need to run `sudo -E howdy test` rather than `sudo howdy test`.
        - The same applies to adding face model.
4. firejail: Install and Enable `firejail` following the instructions in [ArchWiki](https://wiki.archlinux.org/title/Firejail).

### Know Issues

1. Flatpak
    - [Give filesystem access](https://davejansen.com/give-full-filesystem-access-to-flatpak-installed-applications/): use Foliate
    - Apply Theme: [how](https://itsfoss.com/flatpak-app-apply-theme/) and [theme name](https://unix.stackexchange.com/questions/14129/gtk-enable-set-dark-theme-on-a-per-application-basis)
2. Others
    - `wlroot`
        - no displaylink support: [issue](https://gitlab.freedesktop.org/wlroots/wlroots/-/issues/1823)
    - `systemd-resolved`
        - no DoH support: [issue](https://github.com/systemd/systemd/issues/8639)

### Keyboard

1. [How to connect Solfe via bluetooth (BT_CLR)](https://www.reddit.com/r/ErgoMechKeyboards/comments/1j4k8gy/my_nicenano_sofle_wont_connect_via_bluetooth/).
2. [Connect LogiTech K380 keyboard via `bluetoothctl`](https://unix.stackexchange.com/questions/590221/pairing-logitech-k380-in-ubuntu-20-04)

### Notes

1. I have problems connecting to my mouse via BlueTooth sometimes. I follow this [guide](https://discussion.fedoraproject.org/t/bluetooth-device-not-connecting-fedora-40/125138/18) to solve the issue.