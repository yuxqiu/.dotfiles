{ config, ... }:
{
  imports = [ ./scripts/dms-focused-output.nix ];

  xdg.configFile."DankMaterialShell/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${config.dotfiles}/nix/hm/linux/dms/settings.json";
}
