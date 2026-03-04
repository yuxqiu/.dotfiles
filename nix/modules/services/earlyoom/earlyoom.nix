{
  flake.modules.homeManager.linux-base = {
    services.systembus-notify.enable = true;
  };

  flake.modules.systemManager.base =
    {
      pkgs,
      nixosModulesPath,
      ...
    }:
    {
      imports = [
        (nixosModulesPath + "/services/system/earlyoom.nix")
      ];

      services.earlyoom = {
        enable = true;
        enableNotifications = true;
        freeMemThreshold = 10;
        reportInterval = 0;
        extraArgs = [
          "--prefer"
          "^(Web Content|Isolated Web Co)$"
          "--avoid"
          "^(greetd|systemd|systemd-logind|dbus-daemon|dbus-broker|niri)$"
        ];
      };

      # Fix missing ExecStart to run earlyoom, using the service-defined env var EARLYOOM_ARGS
      systemd.services.earlyoom.serviceConfig.ExecStart = "${pkgs.earlyoom}/bin/earlyoom $EARLYOOM_ARGS";

      # Fix missing notification from earlyoom
      # - https://github.com/NixOS/nixpkgs/issues/374959
      systemd.services.earlyoom.serviceConfig.DynamicUser = false;

      systemd.maskedUnits = [
        "systemd-oomd.service"
      ];
    };
}
