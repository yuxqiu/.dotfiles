{ inputs, lib, ... }:
{
  flake.modules.systemManager.base =
    { config, ... }:
    {
      imports = [
        inputs.sops-nix.nixosModules.sops
      ];

      config = lib.mkIf config.my.sops.enable {
        users.groups.keys = { };
      };
    };
}
