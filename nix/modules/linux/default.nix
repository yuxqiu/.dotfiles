{ ... }: {
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
    ./niri/default.nix
  ];

  # enable xdg
  xdg.enable = true;
  xdg.mime.enable = true;

  # add /usr/share to $XDG_DATA_DIRS, critical for xdg-desktop-portal to run
  xdg.systemDirs.data = [ "/usr/share" ];

  home.sessionVariables = { QT_QPA_PLATFORMTHEME = "qt5ct"; };
}
