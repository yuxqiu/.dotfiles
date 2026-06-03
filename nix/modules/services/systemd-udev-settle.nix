{
  flake.modules.nixos.systemd-udev-settle = {
    systemd.services.systemd-udev-settle.enable = false;
  };
}
