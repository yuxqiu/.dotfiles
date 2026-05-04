{
  inputs,
  ...
}:
{
  flake.modules.systemManager.dms =
    {
      config,
      lib,
      ...
    }:
    let
      cfg = config.programs.dank-material-shell.greeter;
      inherit (config.services.greetd.settings.default_session) user;
    in
    {
      imports = [
        inputs.dms.nixosModules.greeter
      ];

      options = {
        fonts.packages = lib.mkOption {
          type = lib.types.raw;
        };

        services.greetd = {
          enable = lib.mkEnableOption "greetd";
          settings.default_session = {
            command = lib.mkOption {
              type = lib.types.str;
            };
            user = lib.mkOption {
              type = lib.types.str;
              default = "greeter";
            };
          };
        };
      };

      config = lib.mkIf cfg.enable {
        systemd.services.greetd.overrideStrategy = "asDropin";

        environment.etc = {
          "greetd/config.toml" = {
            text = ''
              [terminal]
              # The VT to run the greeter on. Can be "next", "current" or a number
              # designating the VT.
              vt = 1

              # The default session, also known as the greeter.
              [default_session]
              command = "${config.services.greetd.settings.default_session.command}"
              user = "greeter"
            '';
            mode = "0644";
            replaceExisting = true;
          };
        };

        users.groups.${user} = { };
        users.users.${user} = {
          isSystemUser = true;
          group = "${user}";
          home = "/var/lib/${user}";
          createHome = true;
          description = "Greetd default session user";
        };
      };
    };
}
