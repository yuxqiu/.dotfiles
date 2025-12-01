{ system, ... }: {
  imports = [
    ./dnscrypt-proxy/dnscrypt-proxy.nix
    ./earlyoom.nix
    ./logind/logind.nix
    ./journald/journald.nix
    ./NetworkManager/NetworkManager.nix
    ./autorestic.nix
    ./fprintd.nix
    ./dms/dms-sys.nix
    ./ddcutil.nix
  ];

  nix = { enable = false; };
  # selinux needs to be disabled for system-manager to work
  # https://github.com/numtide/system-manager/issues/115
  system-manager.allowAnyDistro = true;
  nixpkgs.hostPlatform = system;
}
