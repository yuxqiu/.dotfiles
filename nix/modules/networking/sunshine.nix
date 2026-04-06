{
  flake.modules.homeManager.linux-desktop =
    { config, pkgs, ... }:
    let
      sunshineSettings = {
        controller = "disabled";
        origin_web_ui_allowed = "pc";
        bind_address = config.my.networking.bindAddress;
      };
      settingsFormat = pkgs.formats.keyValue { };
      configFile = settingsFormat.generate "sunshine.conf" sunshineSettings;
    in
    {
      # Modified from nixos/modules/services/networking/sunshine.nix
      # Needed because system-manager does not support systemd.user yet
      systemd.user.services.sunshine = {
        Unit = {
          Description = "Self-hosted game stream host for Moonlight";
          PartOf = [ "graphical-session.target" ];
          Wants = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
          StartLimitIntervalSec = 500;
          StartLimitBurst = 5;
        };

        Install = {
          WantedBy = [ "graphical-session.target" ];
        };

        Service = {
          ExecStart = "/run/wrappers/bin/sunshine ${configFile}";
          Restart = "on-failure";
          RestartSec = "5s";
        };
      };
    };

  flake.modules.systemManager.desktop =
    {
      nixosModulesPath,
      lib,
      ...
    }:
    {
      options = {
        services.avahi = lib.mkOption {
          type = lib.types.raw;
        };
        systemd.user.services.sunshine = lib.mkOption {
          type = lib.types.raw;
        };
      };

      imports = [ (nixosModulesPath + "/services/networking/sunshine.nix") ];

      config = {
        services.sunshine = {
          enable = true;
          openFirewall = false;
          capSysAdmin = true;
        };
      };
    };
}
