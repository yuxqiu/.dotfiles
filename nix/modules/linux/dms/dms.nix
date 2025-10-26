{ config, ... }: {
  xdg.configFile."DankMaterialShell/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.dotfiles}/nix/modules/linux/dms/settings.json";
}
