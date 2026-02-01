{ lib, ... }:
{
  flake.modules.homeManager.base = {
    options.user = {
      dotfiles = lib.mkOption {
        type = lib.types.path;
        apply = toString;
        description = "Location of the dotfiles working copy";
      };

      keys = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = { };
        description = "Personal public keys";
      };
    };
  };

  flake.modules.systemManager.base = {
    options.user = {
      username = lib.mkOption {
        type = lib.types.str;
        description = "Username";
      };
    };
  };
}
