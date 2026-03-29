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
        system = {
          path = lib.mkOption {
            internal = true;
            description = ''
              The packages you want in the boot environment.
            '';
          };
        };
      };

      config = {
        # don't bother managing nix
        nix = {
          enable = false;
        };

        system-manager.allowAnyDistro = true;

        # Modified from upstream at
        # - nixos/modules/config/system-path.nix
        system.path = pkgs.buildEnv {
          name = "system-path";
          paths = config.environment.systemPackages;
          inherit (config.environment) pathsToLink;
          ignoreCollisions = true;
          # !!! Hacky, should modularise.
          # outputs TODO: note that the tools will often not be linked by default
          postBuild = ''
            # Remove wrapped binaries, they shouldn't be accessible via PATH.
            find $out/bin -maxdepth 1 -name ".*-wrapped" -type l -delete
            find $out/bin -maxdepth 1 -name ".*-wrapped_*" -type l -delete

            if [ -x $out/bin/glib-compile-schemas -a -w $out/share/glib-2.0/schemas ]; then
                $out/bin/glib-compile-schemas $out/share/glib-2.0/schemas
            fi
          '';
        };
      };
    };
}
