{
  flake.modules.systemManager.i2c =
    { nixosModulesPath, ... }:
    {
      imports = [
        (nixosModulesPath + "/hardware/i2c.nix")
      ];

      hardware.i2c.enable = true;
    };

  flake.modules.nixos.i2c = {
    hardware.i2c.enable = true;
  };
}
