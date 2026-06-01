{
  flake.modules.homeManager.dolphin =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      applicationsMenu = pkgs.writeTextDir "etc/xdg/menus/applications.menu" (
        builtins.readFile ./applications.menu
      );

      dolphin = pkgs.symlinkJoin {
        name = "dolphin-wrapped";
        paths = [ pkgs.kdePackages.dolphin ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          rm $out/bin/dolphin
          makeWrapper ${pkgs.kdePackages.dolphin}/bin/dolphin $out/bin/dolphin \
            --prefix XDG_CONFIG_DIRS : "${applicationsMenu}/etc/xdg" \
            --run "${lib.getExe' pkgs.kdePackages.kservice "kbuildsycoca6"} --noincremental"
        '';
      };

      inherit (config.lib.stylix) colors;
      colorschemeSlug = lib.concatStrings (
        lib.filter lib.isString (builtins.split "[^a-zA-Z]" colors.scheme)
      );
    in
    {
      home.packages = [
        dolphin
      ];

      qt.kde.settings = {
        dolphinrc.UiSettings.ColorScheme = colorschemeSlug;
      };

      xdg.mimeApps = {
        associations.added = {
          "inode/directory" = [ "org.kde.dolphin.desktop" ];
        };

        defaultApplications = {
          "inode/directory" = [ "org.kde.dolphin.desktop" ];
        };
      };
    };
}
