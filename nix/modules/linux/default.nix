{ pkgs, ... }: {
  imports = [
    ./flatpak.nix
    ./captive-browser/default.nix
    ./wofi.nix
    ./mako.nix
    ./waybar/default.nix
    ./fcitx5.nix
    ./gtk.nix
    ./vscode.nix
    ./zsh.nix
    ./niri/default.nix
    ./qt.nix
  ];

  home.packages = with pkgs; [
    blueman
    brightnessctl
    clipman
    desktop-file-utils
    dotool
    networkmanagerapplet
    networkmanager
    pavucontrol
    swaybg
    swayidle
    wl-clipboard
    xdg-utils
  ];

  # The following packages are also partially managed by systems for now:
  # - niri and portals (gtk and gnome)

  # enable xdg (xdg-mime is default enabled)
  xdg.enable = true;

  # add /usr/share to $XDG_DATA_DIRS, critical for xdg-desktop-portal to run
  xdg.systemDirs.data = [ "/usr/share" ];
}
