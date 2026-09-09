{
  flake.modules.nixos.earlyoom = {
    services.earlyoom = {
      enable = true;
      enableNotifications = true;
      freeMemThreshold = 10;
      extraArgs = [
        "--prefer"
        "^(Web Content|Isolated Web Co)$"
        "--avoid"
        "^(greetd|systemd|systemd-logind|dbus-daemon|dbus-broker|niri)$"
      ];
    };

    systemd.oomd.enable = false;
  };
}
