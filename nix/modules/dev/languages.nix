{
  flake.modules.homeManager.languages =
    { lib, config, ... }:
    {
      options.my.dev.languages = lib.mkOption {
        type = lib.types.attrsOf (lib.types.submodule ({ name, ... }: {
          options = {
            toolchain = lib.mkOption {
              type = lib.types.listOf lib.types.package;
              default = [ ];
            };

            lsp = lib.mkOption {
              type = lib.types.listOf (lib.types.submodule {
                options = {
                  server = lib.mkOption {
                    type = lib.types.str;
                  };
                  package = lib.mkOption {
                    type = lib.types.package;
                  };
                  binary = lib.mkOption {
                    type = lib.types.str;
                  };
                  extraArgs = lib.mkOption {
                    type = lib.types.listOf lib.types.str;
                    default = [ ];
                  };
                  filetypes = lib.mkOption {
                    type = lib.types.listOf lib.types.str;
                    default = [ name ];
                  };
                };
              });
              default = [ ];
            };

            formatter = lib.mkOption {
              type = lib.types.nullOr (lib.types.submodule {
                options = {
                  cmd = lib.mkOption {
                    type = lib.types.str;
                  };
                  package = lib.mkOption {
                    type = lib.types.package;
                  };
                  filetypes = lib.mkOption {
                    type = lib.types.listOf lib.types.str;
                    default = [ name ];
                  };
                };
              });
              default = null;
            };

            linter = lib.mkOption {
              type = lib.types.listOf (lib.types.submodule {
                options = {
                  name = lib.mkOption {
                    type = lib.types.str;
                  };
                  package = lib.mkOption {
                    type = lib.types.package;
                  };
                  filetypes = lib.mkOption {
                    type = lib.types.listOf lib.types.str;
                    default = [ name ];
                  };
                };
              });
              default = [ ];
            };

            treesitter = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ ];
            };
          };
        }));
        default = { };
      };

      config.home.packages = lib.concatLists (
        lib.mapAttrsToList (_: lang:
          lang.toolchain
          ++ map (s: s.package) lang.lsp
          ++ lib.optional (lang.formatter != null) lang.formatter.package
          ++ map (l: l.package) lang.linter
        ) config.my.dev.languages
      );
    };
}
