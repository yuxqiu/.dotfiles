## Note

### Deny

Do not use `stow` to setup
- `logind`
- `journald`
- `earlyoom`

When setup these conf files, directly copy them to corresponding locations
- `logind`: `/etc/systemd`
- `journald`: `/etc/systemd`
- `earlyoom`: `/etc/default`

### Special

- `dnscrypt-proxy`: use `sudo stow dnscrypt -t /`
- `network-manager`: use `sudo stow network-manager -t /`