{
  flake.modules.nixos.yuxqiu-cedrus = {
    services.fprintd.lid-guard = {
      enable = true;
      lidPath = "LID0";
    };
  };
}
