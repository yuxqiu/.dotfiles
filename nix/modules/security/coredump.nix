{
  flake.modules.nixos.coredump = {
    systemd.coredump.settings.Coredump = {
      Storage = "none";
      ProcessSizeMax = 0;
    };
  };
}