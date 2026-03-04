{
  flake.modules.systemManager.base =
    {
      lib,
      ...
    }:
    {
      # Hack for importing dnscrypt-proxy from nixos
      options.networking.nameservers = lib.mkOption {
        type = lib.types.raw;
      };
    };
}
