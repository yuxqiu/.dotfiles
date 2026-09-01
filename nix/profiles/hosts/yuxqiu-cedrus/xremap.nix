{
  flake.modules.nixos.yuxqiu-cedrus-xremap = {
    services.xremap = {
      userName = "yuxqiu";
      config.modmap = [
        {
          name = "internal-keyboard-remaps";
          device.only = [ "AT Translated Set 2 keyboard" ];
          remap = {
            "KEY_LEFTMETA" = "KEY_LEFTALT";
            "KEY_LEFTALT" = "KEY_LEFTCTRL";
            "KEY_CAPSLOCK" = "KEY_ESC";
            "KEY_ESC" = "KEY_CAPSLOCK";
          };
        }
      ];
    };
  };
}
