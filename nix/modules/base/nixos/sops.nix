{ inputs, ... }:
{
  flake.modules.nixos.base = {
    imports = [
      inputs.sops-nix.nixosModules.sops
    ];

    users.groups.keys = { };
  };
}
