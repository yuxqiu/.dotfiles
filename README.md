## Linux (Fedora)

### General

1. Use `config/dnf` to restore all the installed packages.
2. Install [OpenSnitch](https://github.com/evilsocket/opensnitch)
    - [Disable Automatic Metadata Synchronizing](https://www.reddit.com/r/Fedora/comments/p10a5o/comment/j5ysqw1/)
3. Install niri
    - `sudo dnf copr enable yalter/niri` and `sudo dnf install niri` on Fedora.
    - Setup [xwayland-satellite](https://github.com/YaLTeR/niri/wiki/Xwayland) and [gtk file picker](https://github.com/YaLTeR/niri/wiki/Important-Software#portals).
4. Stop abrt \[Optional\].
    1. [Disbale auto-reporting](https://wiki.centos.org/TipsAndTricks(2f)ABRT.html).
    2. Disbale abrt related service: [1](https://unix.stackexchange.com/questions/556351/what-are-the-risks-for-disable-the-abrtd-service) and [2](https://robbinespu.gitlab.io/posts/disable-abrt-fedora/).
5. SDDM
    - Use [catppuccin/sddm](https://github.com/catppuccin/sddm) theme.
    - Follow the [Arch SDDM guide](https://wiki.archlinux.org/title/SDDM) to setup SDDM Theme.
6. Run `setup.sh` to setup the configuration files.

### DoH

1. Disable and stop `systemd-resolved` by following [this guide](https://askubuntu.com/questions/907246/how-to-disable-systemd-resolved-in-ubuntu).

### Others

1. Nerd Dictation: Follow the [installation guide](https://github.com/ideasman42/nerd-dictation) to install `vosk` and `dotool`.
2. Howdy: Follow the [guide](https://github.com/boltgolt/howdy/issues/1004) to install `howdy-beta` and configure PAM.
    - To test `howdy`, you might need to run `sudo -E howdy test` rather than `sudo howdy test`.
        - The same applies to adding face model.
3. firejail: Install and Enable `firejail` following the instructions in [ArchWiki](https://wiki.archlinux.org/title/Firejail).

### Others

1. Watchlist
    - `wlroot`
        - no displaylink support: [issue](https://gitlab.freedesktop.org/wlroots/wlroots/-/issues/1823)
    - `systemd-resolved`
        - no DoH support: [issue](https://github.com/systemd/systemd/issues/8639)
2. Keyboard
   - [How to connect Solfe via bluetooth (BT_CLR)](https://www.reddit.com/r/ErgoMechKeyboards/comments/1j4k8gy/my_nicenano_sofle_wont_connect_via_bluetooth/).
   - [Connect LogiTech K380 keyboard via `bluetoothctl`](https://unix.stackexchange.com/questions/590221/pairing-logitech-k380-in-ubuntu-20-04)
3. Mouse
   - I have problems connecting to my mouse via BlueTooth sometimes. I follow this [guide](https://discussion.fedoraproject.org/t/bluetooth-device-not-connecting-fedora-40/125138/18) to solve the issue.