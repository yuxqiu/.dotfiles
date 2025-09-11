{ lib, pkgs, config, ... }: {
  home.packages = with pkgs; [ flatpak ];

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
        # Deny network access by default
        Context.shared = [ "!network" ];

        Context.filesystems = [
          "~/.themes:ro" # Read-only access to ~/.themes
          "~/.icons:ro" # Read-only access to ~/.icons
        ];

        Environment = {
          # Fix un-themed cursor in some Wayland apps
          XCURSOR_PATH = "/run/host/user-share/icons:/run/host/share/icons";

          # Force correct theme for some GTK apps
          GTK_THEME = "Adwaita:dark";
        };
      };

      "com.github.johnfactotum.Foliate" = {
        Context.filesystems = [
          "home:ro" # Enable read access to home directory (e.g., for loading e-books)
        ];
      };

      "xyz.armcord.ArmCord" = {
        # Enable network for ArmCord
        Context.shared = [ "network" ];
      };

      "com.github.IsmaelMartinez.teams_for_linux" = {
        # Enable network for Microsoft Teams
        Context.shared = [ "network" ];
      };

      "io.github.ungoogled_software.ungoogled_chromium" = {
        # Enable network for Microsoft Teams
        Context.shared = [ "network" ];
      };

      "org.localsend.localsend_app" = {
        # Enable network for ArmCord
        Context.shared = [ "network" ];
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
