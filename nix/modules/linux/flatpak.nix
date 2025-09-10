{ pkgs, config, lib, ... }: {
  services.flatpak = {
    enable = true;
    remotes = {
      "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      # "flathub-beta" = "https://dl.flathub.org/beta-repo/flathub-beta.flatpakrepo";
    };
    packages = [
      "com.github.IsmaelMartinez.teams_for_linux"
      "com.github.PintaProject.Pinta"
      "com.github.johnfactotum.Foliate"
      "com.github.tchx84.Flatseal"
      "io.github.seadve.Kooha"
      "io.github.ungoogled_software.ungoogled_chromium"
      "md.obsidian.Obsidian"
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
        sockets = [ "wayland" "!x11" "!fallback-x11" ];

        environment = {
          # Fix un-themed cursor in some Wayland apps
          XCURSOR_PATH = "/run/host/user-share/icons:/run/host/share/icons";

          # Force correct theme for some GTK apps
          GTK_THEME = "Adwaita:dark";
        };
      };
    };
  };

  home.activation.updateDesktopCache =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run ${pkgs.desktop-file-utils}/bin/update-desktop-database ${config.home.homeDirectory}/.local/share/flatpak/exports/share/applications/
    '';
}
