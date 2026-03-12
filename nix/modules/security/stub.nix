{
  flake.modules.systemManager.base =
    { lib, ... }:
    {
      # stub to make the upstream nginx.nix happy
      options = {
        security = {
          dhparams = lib.mkOption {
            type = lib.types.raw;
          };
          pam = lib.mkOption {
            type = lib.types.raw;
          };
        };
      };
    };
}
