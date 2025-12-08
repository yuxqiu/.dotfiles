{ config, ... }: {
  imports = [ ./scripts/dms-focused-output.nix ];

  xdg.configFile."DankMaterialShell/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.dotfiles}/nix/modules/hm/linux/dms/settings.json";
}
