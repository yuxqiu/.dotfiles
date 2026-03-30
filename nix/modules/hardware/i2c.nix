{
  flake.modules.systemManager.base =
    { nixosModulesPath, ... }:
    {
      imports = [
        (nixosModulesPath + "/hardware/i2c.nix")
      ];

      hardware.i2c.enable = true;
    };
}
