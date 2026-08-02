{
  flake.modules.nixos.time =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      services.timesyncd.enable = false;

      environment.systemPackages = [
        (pkgs.writeShellApplication {
          name = "sync-time";
          runtimeInputs = with pkgs; [ ntp ];
          text = ''
            exec sntp -S ${lib.escapeShellArgs config.networking.timeServers} "$@"
          '';
        })
      ];
    };
}
