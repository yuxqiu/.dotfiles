{ pkgs, ... }:
{
  imports = [
    ./alacritty.nix
    ./distrobox.nix
    ./dolphin.nix
    ./fcitx5.nix
    ./flatpak.nix
    ./gtk.nix
    ./opensnitch.nix
    ./qt.nix
    ./ssh.nix
    ./stylix.nix
    ./systemd.nix
    ./vpn.nix
    ./wayscriber.nix
    ./wl-kbptr.nix
    ./xdg.nix
    ./zsh.nix

    ./captive-browser/default.nix
    ./dms/dms.nix
    ./niri/default.nix
  ];

  home.packages = with pkgs; [
    blueman
    desktop-file-utils
    iputils
    libnotify
    networkmanager
    patch
    system-manager
    traceroute
    xdg-utils
  ];

  # improve generic linux compatibility (on non NixOS)
  targets.genericLinux.enable = !builtins.pathExists /etc/NIXOS;
  targets.genericLinux.gpu.enable = false; # already managed by system-manager
}
