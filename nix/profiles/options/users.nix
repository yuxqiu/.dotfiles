{ lib, ... }:
{
  flake.modules.homeManager.base = {
    options.my.user = {
      name = lib.mkOption {
        type = lib.types.str;
        description = "Full name, for tool identity (e.g. VCS commit author)";
      };
      email = lib.mkOption {
        type = lib.types.str;
        description = "Email address, for tool identity (e.g. VCS commit author)";
      };
      keys = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = { };
        description = "Personal public keys";
      };
    };
  };

  flake.modules.nixos.base = {
    options.my.username = lib.mkOption {
      type = lib.types.str;
      description = "Main user of the system";
    };
  };
}
