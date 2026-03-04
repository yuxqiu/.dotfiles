{
  flake.modules.systemManager.base =
    {
      lib,
      ...
    }:
    {
      # Hack for importing opensnitch from nixos
      options.security.auditd = lib.mkOption {
        type = lib.types.raw;
      };
    };
}
