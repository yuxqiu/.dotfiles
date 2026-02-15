{ lib, ... }:
let
  sop_option = lib.mkOption {
    type = lib.types.submodule {
      options = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Whether to enable sops";
        };
      };
    };
  };
in
{
  flake.modules.homeManager.base = {
    options.my.sops = sop_option;
  };

  flake.modules.systemManager.base = {
    options.my.sops = sop_option;
  };
}
