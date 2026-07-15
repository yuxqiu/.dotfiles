{
  flake.modules.homeManager.dms =
    { pkgs, ... }:
    {
      programs.dank-material-shell.plugins.screenCaptureToolbar = {
        enable = true;
        settings = {
          saveToDisk = false;
          showNotify = false;
          showPointer = false;
          videoCustomPath = "~/Downloads";
        };
      };

      home.packages = with pkgs; [
        slurp
        grim
        satty
        wl-clipboard
      ];

      wayland.windowManager.niri.settings.binds."Mod+Shift+S" = {
        _props.hotkey-overlay-title = "Screen Capture";
        spawn = [
          "dms"
          "ipc"
          "call"
          "screenCaptureToolbar"
          "toggle"
        ];
      };
    };
}
