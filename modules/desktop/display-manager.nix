{
  flake.modules.nixos.display-manager = {
    services.greetd = {
      enable = true;
    };
  };
}
