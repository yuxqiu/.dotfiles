{
  flake.modules.nixos.accessibility = {
    services.speechd.enable = false;
    services.orca.enable = false;
  };
}
