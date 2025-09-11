{ pkgs, ... }: {
  imports = [
    ./flatpak.nix
    ./captive-browser/default.nix
    ./wofi.nix
    ./mako.nix
    ./dnscrypt-proxy/default.nix
    ./waybar/default.nix
    ./clipman.nix
  ];

  # enable xdg
  xdg.enable = true;

  # TODO: desktop-file-utils can be removed when vscode is ready
  home.packages = with pkgs; [ blueman desktop-file-utils xwayland-satellite ];

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
