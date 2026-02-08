# Modified from https://github.com/nix-community/home-manager/pull/5677
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.wlr-which-key;
  yamlFormat = pkgs.formats.yaml { };
in
{
  meta.maintainers = with lib.maintainers; [
    LilleAila
    mightyiam
    minijackson
  ];

  options.programs.wlr-which-key = {
    enable = lib.mkEnableOption "wlr-which-key";

    package = lib.mkPackageOption pkgs "wlr-which-key" { nullable = true; };

    settings = lib.mkOption {
      type = lib.types.submodule { freeformType = yamlFormat.type; };

      default = { };
      example = {
        anchor = "center";
        background = "#282828d0";
        border = "#8ec07c";
        color = "#fbf1c7";
      };

      description = ''
        Settings to be applied to every menu specified under the `menus` option.
      '';
    };

    menus = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          freeformType = yamlFormat.type;

          options.menu = lib.mkOption {
            description = ''
              List of top-level menu entries in the current wlr-which-key format.
              Each item must have at least 'key' and 'desc'.
            '';
            type = lib.types.listOf (
              lib.types.submodule {
                options = {
                  key = lib.mkOption {
                    type = lib.types.oneOf [
                      lib.types.str
                      (lib.types.listOf lib.types.str)
                    ];
                    description = ''
                      Key or list of alternative keys (e.g. "p" or ["Left" "h"]).
                    '';
                  };

                  desc = lib.mkOption {
                    type = lib.types.str;
                    description = "Description shown next to the key";
                  };

                  cmd = lib.mkOption {
                    type = lib.types.nullOr lib.types.str;
                    default = null;
                    description = "Shell command to run (leaf action)";
                  };

                  submenu = lib.mkOption {
                    type = lib.types.nullOr (lib.types.listOf lib.types.attrs); # ← recursive via attrs for simplicity
                    default = null;
                    description = "Nested submenu entries (same structure as top-level menu items)";
                  };

                  # optional extras (if your version supports them)
                  keep_open = lib.mkOption {
                    type = lib.types.bool;
                    default = false;
                    description = "Keep menu open after executing cmd";
                  };
                };
              }
            );
            default = [ ];
            example = [
              {
                key = "p";
                desc = "Power";
                submenu = [
                  {
                    key = "s";
                    desc = "Sleep";
                    cmd = "systemctl suspend";
                  }
                  {
                    key = "r";
                    desc = "Reboot";
                    cmd = "reboot";
                  }
                  {
                    key = "o";
                    desc = "Off";
                    cmd = "poweroff";
                  }
                ];
              }
            ];
          };

          config = cfg.settings;
        }
      );

      default = { };
      example.config = {
        anchor = "center";
        menu = {
          p = {
            desc = "Power";
            submenu = {
              o = {
                cmd = "poweroff";
                desc = "Off";
              };
              r = {
                cmd = "reboot";
                desc = "Reboot";
              };
              s = {
                cmd = "systemctl suspend";
                desc = "Sleep";
              };
            };
          };
        };
      };

      description = ''
        Various configurations for wlr-which-key.

        Each configuration `menus.''${name}` is installed into
        `~/.config/wlr-which-key/''${name}.yaml`.

        This enables you to run: `wlr-which-key ''${name}`.

        To set the default menu, use `programs.wlr-which-key.menus.config`.

        For more information on available options, see:
        <https://github.com/MaxVerevkin/wlr-which-key/>
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = lib.mkIf (cfg.package != null) [ cfg.package ];

    xdg.configFile = lib.mapAttrs' (
      name: value:
      lib.nameValuePair "wlr-which-key/${name}.yaml" {
        source = yamlFormat.generate "wlr-which-key-${name}.yaml" value;
      }
    ) cfg.menus;
  };
}
