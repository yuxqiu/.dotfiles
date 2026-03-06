{
  flake.modules.systemManager.base =
    { lib, ... }:
    {
      config = {
        # don't bother managing nix
        nix = {
          enable = false;
        };

        system-manager.allowAnyDistro = true;
      };

      options.system.stateVersion = lib.mkOption {
        type = lib.types.str;
        # ensure we always apply the latest configs
        # in upstreams by using a large stateVersion
        default = "99.99";
      };
    };
}
