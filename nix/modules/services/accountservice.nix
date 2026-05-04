{
  flake.modules.systemManager.accountservice =
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
