{ ... }:
{
  imports = [
    ./dnscrypt-proxy/dnscrypt-proxy.nix
    ./earlyoom.nix
    ./logind/logind.nix
    ./journald/journald.nix
    ./NetworkManager/NetworkManager.nix
    ./autorestic.nix
    ./fprintd.nix
    ./ddcutil.nix
    ./tuned/tuned.nix
  ];

  # don't bother managing nix
  nix = {
    enable = false;
  };
}
