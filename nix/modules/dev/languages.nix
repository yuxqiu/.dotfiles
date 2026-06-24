{
  flake.modules.homeManager.languages =
    { lib, config, ... }:
    {
      options.my.dev.languages = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule (
            { name, ... }: {
              options = {
                toolchain = lib.mkOption {
                  type = lib.types.listOf lib.types.package;
                  default = [ ];
                };

                lsp = lib.mkOption {
                  type = lib.types.listOf lib.types.package;
                  default = [ ];
                };

                formatter = lib.mkOption {
                  type = lib.types.nullOr lib.types.package;
                  default = null;
                };

                linter = lib.mkOption {
                  type = lib.types.listOf lib.types.package;
                  default = [ ];
                };
              };
            }
          )
        );
        default = { };
      };

      config.home.packages = lib.concatLists (
        lib.mapAttrsToList (
          _: lang:
          lang.toolchain ++ lang.lsp ++ lib.optional (lang.formatter != null) lang.formatter ++ lang.linter
        ) config.my.dev.languages
      );
    };
}
