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

  flake.modules.nixos.accountservice = {
    services.accounts-daemon.enable = true;
  };
}
