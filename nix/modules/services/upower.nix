{
  flake.modules.systemManager.desktop =
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
