{
  flake.modules.homeManager.linux-base =
    { pkgs, ... }:
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
    in
    {
      home.packages = [
        dolphin
      ];
    };
}
