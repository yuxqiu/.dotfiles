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
    ./xdg.nix
    ./stylix.nix
    ./opensnitch.nix
    ./ssh.nix
    ./dolphin.nix
    ./distrobox.nix
  ];

  home.packages = with pkgs; [
    blueman
    desktop-file-utils
    iputils
    libnotify
    networkmanager
    patch
    traceroute
    xdg-utils
    inputs.system-manager.packages.${pkgs.stdenv.system}.default
  ];

  # improve generic linux compatibility (on non NixOS)
  targets.genericLinux.enable = !builtins.pathExists /etc/NIXOS;
  targets.genericLinux.gpu.enable = false; # already managed by system-manager
}
