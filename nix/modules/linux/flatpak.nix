{ lib, pkgs, config, ... }: {
  home.packages = with pkgs; [
    flatpak
  ];

  services.flatpak = {
    enable = true;
    update.onActivation = true;
    packages = [
      "com.github.IsmaelMartinez.teams_for_linux"
      "com.github.PintaProject.Pinta"
      "com.github.johnfactotum.Foliate"
      "com.github.tchx84.Flatseal"
      "io.github.seadve.Kooha"
      "io.github.ungoogled_software.ungoogled_chromium"
      "org.gnome.Calculator"
      "org.gnome.FileRoller"
      "org.kde.dolphin"
      "org.libreoffice.LibreOffice"
      "org.localsend.localsend_app"
      "org.videolan.VLC"
      "org.xfce.ristretto"
      "xyz.armcord.ArmCord"
    ];
    overrides = {
      global = {
        # Force Wayland by default
        Context.sockets = [ "wayland" "!x11" "!fallback-x11" ];

        Environment = {
          # Fix un-themed cursor in some Wayland apps
          XCURSOR_PATH = "/run/host/user-share/icons:/run/host/share/icons";

          # Force correct theme for some GTK apps
          GTK_THEME = "Adwaita:dark";
        };
      };
    };
  };

  # https://github.com/gmodena/nix-flatpak/issues/31
  xdg.systemDirs.data = [
    "/var/lib/flatpak/exports/share"
    "${config.home.homeDirectory}/.local/share/flatpak/exports/share"
  ];

  home.activation.updateDesktopCache =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run ${pkgs.desktop-file-utils}/bin/update-desktop-database ${config.home.homeDirectory}/.local/share/flatpak/exports/share/applications/
    '';
}
