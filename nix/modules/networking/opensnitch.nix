{
  flake.modules.homeManager.linux-desktop =
    { pkgs, lib, ... }:
    {
      home.packages = [ pkgs.opensnitch-ui ];

      # Add restart as opensnitch-ui is started too early and crashes consistently.
      services.opensnitch-ui.enable = true;
      systemd.user.services.opensnitch-ui = {
        Service = {
          Restart = "on-failure";
          RestartSec = "5";
        };
      };

      wayland.windowManager.niri.settings.window-rule = lib.mkAfter [
        {
          match = {
            _props."app-id" = "opensnitch_ui";
          };

          background-effect.blur = true;
          opacity = 0.6;
        }

        {
          match = {
            _props."app-id"._raw = ''r#"opensnitch_ui$"#'';
          };

          open-floating = true;
        }
      ];
    };

  flake.modules.systemManager.desktop =
    { nixosModulesPath, lib, ... }:
    {
      # Hack for importing opensnitch from nixos
      options.security.auditd = lib.mkOption {
        type = lib.types.raw;
      };

      imports = [ (nixosModulesPath + "/services/security/opensnitch.nix") ];

      config = {
        services.opensnitch = {
          enable = true;
          settings = {
            Ebpf.ModulesPath = null;
          };
        };
      };
    };
}
