{
  flake.modules.nixos.bluetooth = {
    hardware.bluetooth = {
      enable = true;
      settings = {
        General = {
          UserspaceHID = true;
        };
      };
    };
  };
}
