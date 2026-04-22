{ lib, ... }:
{
  flake.modules.homeManager.base = {
    options.my.user = {
      keys = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = { };
        description = "Personal public keys";
      };
    };
  };

  flake.modules.systemManager.base = {
    options.my.username = lib.mkOption {
      type = lib.types.str;
      description = "Main user of the system";
    };
  };
}
