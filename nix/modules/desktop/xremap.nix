{ inputs, ... }:
{
  flake.modules.homeManager.xremap = {
    imports = [ inputs.xremap.homeManagerModules.default ];

    services.xremap = {
      enable = true;
      withNiri = true;
    };
  };

  flake.modules.nixos.xremap =
    { lib, ... }:
    {
      services.udev.extraRules = lib.mkAfter ''
        KERNEL=="uinput", GROUP="input", TAG+="uaccess", MODE:="0660", OPTIONS+="static_node=uinput"
      '';

      boot.kernelModules = [ "uinput" ];
    };
}
