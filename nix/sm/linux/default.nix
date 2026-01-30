{ ... }:
{
  imports = [
    ./autorestic.nix
    ./ddcutil.nix
    ./dms-greeter.nix
    ./docker.nix
    ./earlyoom.nix
    ./fprintd.nix
    ./niri.nix
    ./pam.nix
    ./polkit.nix
    ./wayland-session.nix

    ./dnscrypt-proxy/default.nix
    ./journald/journald.nix
    ./NetworkManager/NetworkManager.nix
    ./opensnitch/default.nix
    ./tuned/tuned.nix
  ];

  # don't bother managing nix
  nix = {
    enable = false;
  };
}
