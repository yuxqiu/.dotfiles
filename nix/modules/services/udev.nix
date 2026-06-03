{
  flake.modules.nixos.udev = {
    systemd.services.systemd-udev-settle.enable = false;
  };
}
