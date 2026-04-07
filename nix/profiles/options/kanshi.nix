{ lib, ... }:
{
  flake.modules.generic.base = {
    options.my.kanshi = {
      externalMonitorName = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "kanshi criteria string for the external monitor.";
      };
    };
  };
}
