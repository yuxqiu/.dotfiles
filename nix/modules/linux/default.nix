{ pkgs, ... }: {
  imports = [
    ./flatpak.nix
    ./captive-browser/default.nix
    ./wofi.nix
    ./mako.nix
    ./dnscrypt-proxy/default.nix
    ./waybar/default.nix
    ./fcitx5.nix
    ./gtk.nix
    ./niri.nix
  ];

  # enable xdg
  xdg.enable = true;
  xdg.mime.enable = true;

  # TODO: desktop-file-utils can be removed when vscode is ready
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
