{
  flake.modules.systemManager.base =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      options = {
        system.stateVersion = lib.mkOption {
          type = lib.types.str;
          # ensure we always apply the latest configs
          # in upstreams by using a large stateVersion
          default = "99.99";
        };
      };

      config = {
        # don't bother managing nix
        nix = {
          enable = false;
        };

        system-manager.allowAnyDistro = true;
      };
    };
}
