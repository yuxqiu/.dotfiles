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
  ];

  home.packages = with pkgs; [
    blueman
    brightnessctl
    clipman
    desktop-file-utils
    networkmanagerapplet
    swaybg
    wl-clipboard
  ];

  # The following packages are managed by systems for now:
  # - niri
  # - portals (gtk and gnome)
  # - swayidle and swaylock
  # - pipewire and wireplumber
  # - mesa-vulkan-drivers

  # enable xdg
  xdg.enable = true;
  xdg.mime.enable = true;

  # add /usr/share to $XDG_DATA_DIRS, critical for xdg-desktop-portal to run
  xdg.systemDirs.data = [ "/usr/share" ];

  home.sessionVariables = { QT_QPA_PLATFORMTHEME = "qt5ct"; };
}
