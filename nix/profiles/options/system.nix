{ lib, ... }:
{
  flake.modules.generic.base = {
    options.my.system = {
      isNixos = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether the system is running on NixOS.";
      };
    };
  };

  flake.modules.nixos.base = {
    options.my.system = {
      isNixos = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether the system is running on NixOS.";
      };
    };
  };
}
