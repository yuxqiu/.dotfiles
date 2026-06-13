{
  flake.modules.nixos.thermald = {
    services.thermald.enable = true;
  };
}