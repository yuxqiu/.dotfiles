{
  flake.modules.nixos.fwupd = {
    services.fwupd.enable = true;

    # Disable the periodic metadata refresh; run `fwupdmgr refresh` manually.
    systemd.timers.fwupd-refresh.enable = false;
  };
}
