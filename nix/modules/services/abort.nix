{
  flake.modules.systemManager.base = {
    systemd.maskedUnits = [
      "abrt-journal-core.service"
      "abrt-oops.service"
      "abrt-vmcore.service"
      "abrt-xorg.service"
      "abrtd.service"
    ];
  };
}
