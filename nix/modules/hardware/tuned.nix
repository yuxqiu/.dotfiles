{
  flake.modules.nixos.tuned = {
    services.tuned.enable = true;
    services.tuned.settings = {
      dynamic_tuning = true;
    };
  };
}
