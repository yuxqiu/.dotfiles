{ lib, ... }:
{
  flake.modules.generic.base = {
    options.my.sops = lib.mkOption {
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
  };
}
