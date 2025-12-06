{ pkgs, ... }: {
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
  ];

  home.packages = with pkgs; [
    blueman
    desktop-file-utils
    dotool
    iputils
    traceroute
    xdg-utils
  ];

  # improve generic linux compatibility
  targets.genericLinux.enable = true;
}
