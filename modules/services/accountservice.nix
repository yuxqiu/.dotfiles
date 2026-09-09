{
  flake.modules.nixos.accountservice = {
    services.accounts-daemon.enable = true;
  };
}
