{ pkgs, config, ... }: {
  home.packages = [ pkgs.flatpak ];

  services.flatpak = {
    enable = true;
    update.onActivation = true;
    uninstallUnused = true; # delete stale/unused packages

    packages = [
      "com.github.PintaProject.Pinta"
      "com.github.johnfactotum.Foliate"
      "com.github.tchx84.Flatseal"
      "io.github.seadve.Kooha"
      "io.github.ungoogled_software.ungoogled_chromium"
      "io.mpv.Mpv"
      "org.gnome.Calculator"
      "org.gnome.FileRoller"
      "org.kde.dolphin"
      "org.libreoffice.LibreOffice"
      "org.localsend.localsend_app"
      "org.xfce.ristretto"
      "org.inkscape.Inkscape"
    ];

    overrides = {
      global = {
        # Force
        # - Wayland by default
        # - No smart cards (pcsc: YubiKey), printer, gpg and ssh
        Context.sockets = [
          "wayland"
          "!x11"
          "!fallback-x11"
          "!pcsc"
          "!cups"
          "!ssh-auth"
          "!gpg-agent"
        ];
        # # Deny network access by default
        Context.shared = [ "!network" "!ipc" ];

        Context.filesystems = [
          "~/.themes:ro" # Read-only access to ~/.themes
          "~/.icons:ro" # Read-only access to ~/.icons
          # Read-only access to nix store, which stores resources like cursors
          # https://wiki.nixos.org/wiki/Cursor_Themes
          "/nix/store:ro"
        ];

        # From
        # - https://github.com/gentmantan/dotfiles/blob/b693ee1893c619f53cfecd7bc154db914262c0b1/modules/nix-flatpak.nix
        "System Bus Policy" = {
          "org.freedesktop.UPower" = "none";
          "org.freedesktop.UDisks2" = "none";
        };
        "Session Bus Policy" = { # Deny some known sandbox escape permissions
          "org.freedesktop.Flatpak" = "none";
          "org.freedesktop.impl.portal.PermissionStore" = "none";
          "org.freedesktop.secrets" = "none";
        };
      };

      "com.github.johnfactotum.Foliate" = {
        Context.filesystems = [
          "home:ro" # Enable read access to home directory (e.g., for loading e-books)
        ];
      };

      "io.github.ungoogled_software.ungoogled_chromium" = {
        Context.shared = [ "network" ];
      };

      "org.localsend.localsend_app" = { Context.shared = [ "network" ]; };

      "org.kde.dolphin" = { Context.sockets = [ "session-bus" "system-bus" ]; };
    };
  };

  # https://github.com/gmodena/nix-flatpak/issues/31
  xdg.systemDirs.data = [
    "/var/lib/flatpak/exports/share"
    "${config.home.homeDirectory}/.local/share/flatpak/exports/share"
  ];
}
