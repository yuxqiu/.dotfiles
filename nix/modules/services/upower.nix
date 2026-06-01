{
  flake.modules.systemManager.upower =
    {
      nixosModulesPath,
      ...
    }:
    {
      imports = [
        (nixosModulesPath + "/services/hardware/upower.nix")
      ];

      services.upower.enable = true;
    };

  flake.modules.nixos.upower = {
    services.upower.enable = true;
  };
}
