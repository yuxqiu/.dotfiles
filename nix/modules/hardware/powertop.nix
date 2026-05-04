{
  flake.modules.systemManager.powertop =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.powertop ];

      systemd.services.powertop-autotune = {
        description = "Powertop autotune";
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.powertop}/bin/powertop --auto-tune";
        };
      };
    };
}
