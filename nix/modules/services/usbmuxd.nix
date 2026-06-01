{
  flake.modules.systemManager.usbmuxd =
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

  flake.modules.nixos.usbmuxd = {
    services.usbmuxd.enable = true;
  };
}
