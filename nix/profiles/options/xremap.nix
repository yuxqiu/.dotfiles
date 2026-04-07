{ lib, ... }:
{
  flake.modules.generic.base = {
    options.my.xremap = {
      internalKeyboardName = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Device name for the internal keyboard (xremap device.only)";
      };
    };
  };
}
