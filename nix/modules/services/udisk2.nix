{
  flake.modules.systemManager.desktop =
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
}
