{
  flake.modules.nixos.snowflake-dracaena = {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
  };
}
