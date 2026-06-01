{
  flake.modules.nixos.time =
    { pkgs, ... }:
    {
      services.timesyncd.enable = false;

      environment.systemPackages = [
        (pkgs.writeShellApplication {
          name = "sync-time";
          runtimeInputs = with pkgs; [ ntp ];
          text = ''
            ntpd -gq "$@"
          '';
        })
      ];
    };
}
