{
  flake.modules.systemManager.udisk2 =
    {
      nixosModulesPath,
      ...
    }:
    {
      imports = [
        (nixosModulesPath + "/services/hardware/udisks2.nix")
      ];

      services.udisks2.enable = true;
    };

  flake.modules.nixos.udisk2 = {
    services.udisks2.enable = true;
  };
}
