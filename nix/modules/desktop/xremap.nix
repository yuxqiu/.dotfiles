{ inputs, ... }:
{
  flake.modules.homeManager.linux-desktop =
    {
      config,
      lib,
      ...
    }:
    {
      imports = [ inputs.xremap.homeManagerModules.default ];

      services.xremap = {
        enable = true;
        withNiri = true;

        config.modmap = [
          {
            name = "internal-keyboard-remaps";
            device.only = lib.mkIf (config.my.xremap.internalKeyboardName != null) [
              config.my.xremap.internalKeyboardName
            ];
            remap = {
              "KEY_LEFTCTRL" = "KEY_COMPOSE";
              "KEY_LEFTMETA" = "KEY_LEFTCTRL";
              "KEY_CAPSLOCK" = "KEY_ESC";
              "KEY_ESC" = "KEY_CAPSLOCK";
              "KEY_RIGHTMETA" = "KEY_LEFTCTRL";
              "KEY_RIGHTALT" = "KEY_LEFTALT";
            };
          }
        ];
      };
    };

  flake.modules.systemManager.desktop =
    { lib, ... }:
    {
      # give members of the input group permission to make output devices
      services.udev.extraRules = lib.mkAfter ''
        KERNEL=="uinput", GROUP="input", TAG+="uaccess", MODE:="0660", OPTIONS+="static_node=uinput"
      '';

      boot.kernelModules = [ "uinput" ];
    };
}
