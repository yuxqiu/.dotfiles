{ pkgs, ... }: {
  imports = [ ./niriswitcher.nix ];
  # Here, only packages that are closely related to niri are managed
  home.packages = with pkgs; [ xwayland-satellite ];

  home.file.".config/niri/5120x2880.png".source = ./5120x2880.png;
  home.file.".config/niri/config.kdl".source = ./config.kdl;
  home.file.".config/niri/dictation".source = ./dictation;

  xdg.configFile."xdg-desktop-portal/niri-portals.conf".text = ''
    [preferred]
    default=gnome;gtk;
    org.freedesktop.impl.portal.Access=gtk;
    org.freedesktop.impl.portal.Notification=gtk;
    org.freedesktop.impl.portal.Secret=gnome-keyring;
    org.freedesktop.impl.portal.FileChooser=gtk;
  '';
}
