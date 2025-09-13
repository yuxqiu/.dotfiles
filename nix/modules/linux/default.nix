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
  ];

  # enable xdg
  xdg.enable = true;
  xdg.mime.enable = true;

  home.packages = with pkgs; [
    blueman
    clipman
    desktop-file-utils
    xwayland-satellite
    swaybg
    wl-clipboard
  ];
  home.sessionVariables = { QT_QPA_PLATFORMTHEME = "qt5ct"; };

  # xdg.desktopEntries = {
  #   firefox = {
  #     name = "Firefox";
  #     exec = "${pkgs.firefox}/bin/firefox %U";
  #     terminal = false;
  #     type = "Application";
  #     icon = "${pkgs.firefox}/share/icons/hicolor/128x128/apps/firefox.png";
  #     categories = [ "Network" "WebBrowser" ];
  #   };
  # };
}
