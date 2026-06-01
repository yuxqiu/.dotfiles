{
  flake.modules.nixos.journald = {
    services.journald.extraConfig = "SystemMaxUse=50M";
  };
}
