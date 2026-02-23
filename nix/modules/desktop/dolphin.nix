{
  flake.modules.homeManager.linux-desktop =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      # https://github.com/rumboon/dolphin-overlay
      dolphin = pkgs.kdePackages.dolphin.overrideAttrs (oldAttrs: {
        nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [ pkgs.makeWrapper ];

        postInstall = (oldAttrs.postInstall or "") + ''
          wrapProgram $out/bin/dolphin \
            --set XDG_CONFIG_DIRS "${pkgs.libsForQt5.kservice}/etc/xdg:$XDG_CONFIG_DIRS" \
            --set QT_QPA_PLATFORMTHEME "gtk3" \
            --run "${pkgs.kdePackages.kservice}/bin/kbuildsycoca6 --noincremental ${pkgs.libsForQt5.kservice}/etc/xdg/menus/applications.menu"
        '';
      });

      # Copied from how stylix apply kde themes
      # - stylix/modules/kde/hm.nix
      inherit (config.lib.stylix) colors;
      colorschemeSlug = lib.concatStrings (
        lib.filter lib.isString (builtins.split "[^a-zA-Z]" colors.scheme)
      );
    in
    {
      home.packages = [
        dolphin
      ];

      # apply stylix theme to dolphin
      qt.kde.settings = {
        dolphinrc.UiSettings.ColorScheme = colorschemeSlug;
      };
    };
}
