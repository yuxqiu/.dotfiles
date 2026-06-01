{
  flake.modules.nixos.bluetooth = {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = false;
      settings = {
        General = {
          UserspaceHID = true;
        };
      };
    };
  };
}
