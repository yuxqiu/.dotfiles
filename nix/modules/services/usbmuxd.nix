{
  flake.modules.systemManager.desktop =
    {
      nixosModulesPath,
      ...
    }:
    {
      imports = [
        (nixosModulesPath + "/services/hardware/usbmuxd.nix")
      ];

      services.usbmuxd.enable = true;
    };
}
