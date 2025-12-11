## Linux (Fedora)

### General

1. Run `setup.sh` to setup the configuration files.
2. DoH: Disable and stop `systemd-resolved` by following [this guide](https://askubuntu.com/questions/907246/how-to-disable-systemd-resolved-in-ubuntu).

### Devices

1. Fingerprint Reader
    - Install [libfprint-CS9711](https://github.com/ddlsmurf/libfprint-CS9711).
2. Displaylink
    - Download driver from [displaylink-rpm](https://github.com/displaylink-rpm/displaylink-rpm/) (need to match Fedora version).
    - [Displaylink on Asahi Linux](https://www.reddit.com/r/AsahiLinux/comments/1j311ya/displaylink_for_mb_pro_2020_13_m1_on_asahi_fedora/). The rpm install works directly now.
3. External Monitor
    - [Setup `i2c` group](https://www.ddcutil.com/i2c_permissions_using_group_i2c/) and add current user to it.
4. IOS
    - Connect IOS in Fedora using [openssl-weak.conf](https://github.com/libimobiledevice/libimobiledevice/issues/1606).
    - [Mount IOS device](https://wiki.archlinux.org/title/IOS).

### Others

1. Watchlist
    - `systemd-resolved`
        - no DoH support: [issue](https://github.com/systemd/systemd/issues/8639)
2. Keyboard
   - [How to connect Solfe via bluetooth (BT_CLR)](https://www.reddit.com/r/ErgoMechKeyboards/comments/1j4k8gy/my_nicenano_sofle_wont_connect_via_bluetooth/).
   - [Connect LogiTech K380 keyboard via `bluetoothctl`](https://unix.stackexchange.com/questions/590221/pairing-logitech-k380-in-ubuntu-20-04)
3. Mouse
   - I have problems connecting to my mouse via BlueTooth sometimes. I follow this [guide](https://discussion.fedoraproject.org/t/bluetooth-device-not-connecting-fedora-40/125138/18) to solve the issue.