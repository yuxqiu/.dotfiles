{
  flake.modules.nixos.usbguard = {
    services.usbguard = {
      implicitPolicyTarget = "block";
      dbus.enable = true;
    };
  };

  flake.modules.homeManager.usbguard =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.usbguard-notifier ];

      systemd.user.services.usbguard-notifier = {
        Unit = {
          Description = "USBGuard notification daemon";
          After = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = "${pkgs.usbguard-notifier}/bin/usbguard-notifier";
          Restart = "on-failure";
          RestartSec = 5;
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
      };
    };
}
