{ pkgs, ... }: {
  imports = [
    ./flatpak.nix
    ./captive-browser/default.nix
    ./wofi.nix
    ./mako.nix
    ./waybar/default.nix
    ./fcitx5.nix
    ./gtk.nix
    ./niri.nix
    ./vscode.nix
    ./zsh.nix
  ];

  # enable xdg
  xdg.enable = true;
  xdg.mime.enable = true;

  home.packages = with pkgs; [
    blueman
    clipman
    desktop-file-utils
    networkmanagerapplet
    xwayland-satellite
    swaybg
    wl-clipboard
  ];
  home.sessionVariables = { QT_QPA_PLATFORMTHEME = "qt5ct"; };
}
