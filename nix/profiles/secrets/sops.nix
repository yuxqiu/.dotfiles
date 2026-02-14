{ inputs, ... }:
{
  flake.modules.systemManager.base = {
    imports = [
      inputs.sops-nix.nixosModules.sops
    ];

    users.groups.keys = { };
  };
}
