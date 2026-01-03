{ pkgs, ... }:
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
}
