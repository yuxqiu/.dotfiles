{
  flake.modules.systemManager.base =
    {
      lib,
      ...
    }:
    {
      # Hack for importing earlyoom from nixos
      # - systembus-notify is managed by home manager
      options.services.systembus-notify = lib.mkOption {
        type = lib.types.raw;
      };
    };
}
