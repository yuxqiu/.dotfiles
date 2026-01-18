{
  inputs,
  config,
  pkgs,
  ...
}:
{
  home.packages = [
    inputs.tun2proxy.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  systemd.user.services.xray = {
    Unit = {
      Description = "xray-core";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };

    Service = {
      Type = "exec";
      ExecStart = "${pkgs.xray}/bin/xray -c ${config.xdg.configHome}/xray/config.json";
      Restart = "on-failure";
      RestartSec = 3;
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
