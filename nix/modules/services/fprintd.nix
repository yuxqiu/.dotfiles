{
  flake.modules.nixos.fprintd =
    { pkgs, ... }:
    {
      services.fprintd.enable = true;
      environment.systemPackages = with pkgs; [
        libfprint
        fprintd
      ];
    };
}
