{
  flake.modules.homeManager.zed =
    { config, lib, ... }:
    {
      programs.zed-editor.extensions = lib.mkIf (config.my.dev.languages ? typos) [ "typos" ];
    };
}
