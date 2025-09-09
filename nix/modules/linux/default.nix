{ system, pkgs, ... }: {
  imports =
    [ ./flatpak.nix ./captive-browser/default.nix ./wofi.nix ./mako.nix ];

  # enable xdg
  xdg.enable = true;

  home.packages = with pkgs; [ blueman ];

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
