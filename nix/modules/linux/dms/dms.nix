{ config, pkgs, ... }: {
  xdg.configFile."DankMaterialShell/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.dotfiles}/nix/modules/linux/dms/settings.json";

  home.packages = [
    (pkgs.stdenvNoCC.mkDerivation {
      name = "inter-variable-font";
      src = pkgs.fetchurl {
        url =
          "https://github.com/rsms/inter/raw/refs/tags/v4.1/docs/font-files/InterVariable.ttf";
        sha256 =
          "sha256-SYmxJZJJkbkNBbLRbg44jEj31buLMFObv5x1UnjQzK8="; # Replace with actual hash
      };
      dontUnpack = true;
      installPhase = ''
        mkdir -p $out/share/fonts/truetype
        cp $src $out/share/fonts/truetype/InterVariable.ttf
      '';
    })
  ];
}
