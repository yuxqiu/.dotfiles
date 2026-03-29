{
  flake.modules.systemManager.base =
    {
      nixosModulesPath,
      ...
    }:
    {
      imports = [
        (nixosModulesPath + "/services/desktops/accountsservice.nix")
      ];

      services.accounts-daemon.enable = true;
    };
}
