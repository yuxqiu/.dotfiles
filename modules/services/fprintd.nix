{ inputs, ... }:
{
  flake.modules.nixos.fprintd =
    { pkgs, ... }:
    {
      imports = [ inputs.fingerprint-lid-guard.nixosModules.default ];

      services.fprintd.enable = true;

      environment.systemPackages = with pkgs; [
        libfprint
        fprintd
      ];
    };
}
