{ inputs, pkgs, ... }:
{
  imports = [
    ./flatpak.nix
    ./captive-browser/default.nix
    ./fcitx5.nix
    ./gtk.nix
    ./zsh.nix
    ./niri/default.nix
    ./qt.nix
    ./wl-kbptr.nix
    ./dms/dms.nix
    ./wayscriber.nix
    ./systemd.nix
    ./cursor.nix
    ./xdg.nix
    ./stylix.nix
    ./opensnitch.nix
  ];

  home.packages = with pkgs; [
    blueman
    desktop-file-utils
    iputils
    kdePackages.dolphin
    libnotify
    traceroute
    xdg-utils
    inputs.system-manager.packages.${pkgs.stdenv.system}.default
  ];

  # improve generic linux compatibility (on non NixOS)
  targets.genericLinux.enable = !builtins.pathExists /etc/NIXOS;
  targets.genericLinux.gpu.enable = false; # already managed by system-manager
}
