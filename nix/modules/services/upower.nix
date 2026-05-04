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
}
