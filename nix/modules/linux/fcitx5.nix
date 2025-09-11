{ pkgs, ... }:

{
  # Install fcitx5 and necessary packages
  home.packages = with pkgs; [
    fcitx5 # Core fcitx5 framework
    fcitx5-configtool # GUI configuration tool
    fcitx5-gtk # GTK integration for GTK apps
    fcitx5-chinese-addons # Chinese Pinyin input method
    fcitx5-mozc
  ];

  # fcitx5 configuration via Home Manager
  i18n.inputMethod = {
    type = "fcitx5";
    fcitx5.addons = with pkgs; [ fcitx5-chinese-addons fcitx5-mozc fcitx5-gtk ];
    fcitx5.waylandFrontend = true; # Enable Wayland support
  };

  # Autostart fcitx5
  systemd.user.services.fcitx5 = {
    Unit = {
      Description = "Fcitx5 Input Method Framework";
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.fcitx5}/bin/fcitx5 -d";
      Restart = "on-failure";
    };
    Install = { WantedBy = [ "graphical-session.target" ]; };
  };

  # How to setup fcitx5 environment variable
  # - https://fcitx-im.org/wiki/Using_Fcitx_5_on_Wayland
  gtk = {
    gtk3.extraConfig = { gtk-im-module = "fcitx"; };
    gtk4.extraConfig = { gtk-im-module = "fcitx"; };
  };
  home.sessionVariables = {
    QT_IM_MODULE = "fcitx";
    QT_IM_MODULES = "wayland;fcitx;ibus";
    XMODIFIERS = "@im=fcitx";
  };
}
