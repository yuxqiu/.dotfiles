{ pkgs, config, lib, ... }: {
  home.packages = with pkgs; [ flatpak ];

  services.flatpak = {
    enable = true;
    remotes = {
      "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      # "flathub-beta" = "https://dl.flathub.org/beta-repo/flathub-beta.flatpakrepo";
    };
    packages = [
      "flathub:app/com.github.IsmaelMartinez.teams_for_linux//stable"
      "flathub:app/com.github.PintaProject.Pinta//stable"
      "flathub:app/com.github.johnfactotum.Foliate//stable"
      "flathub:app/com.github.tchx84.Flatseal//stable"
      "flathub:app/io.github.seadve.Kooha//stable"
      "flathub:app/io.github.ungoogled_software.ungoogled_chromium//stable"
      "flathub:app/md.obsidian.Obsidian//stable"
      "flathub:app/org.gnome.Calculator//stable"
      "flathub:app/org.gnome.FileRoller//stable"
      "flathub:app/org.kde.dolphin//stable"
      "flathub:app/org.libreoffice.LibreOffice//stable"
      "flathub:app/org.localsend.localsend_app//stable"
      "flathub:app/org.videolan.VLC//stable"
      "flathub:app/org.xfce.ristretto//stable"
      "flathub:app/xyz.armcord.ArmCord//stable"
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
