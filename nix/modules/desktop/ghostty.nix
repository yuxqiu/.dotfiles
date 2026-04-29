{
  flake.modules.homeManager.desktop = {
    programs.ghostty = {
      enable = true;

      settings = {
        window-padding-x = 10;
        window-padding-y = 23;
        window-padding-balance = true;
        background-blur = true;
        background-opacity = 0.6;
        quit-after-last-window-closed = false;

        keybind = [
          "ctrl+alt+h=goto_split:left"
          "ctrl+alt+l=goto_split:right"
          "ctrl+alt+k=goto_split:top"
          "ctrl+alt+j=goto_split:bottom"
          "ctrl+alt+shift+h=new_split:left"
          "ctrl+alt+shift+l=new_split:right"
          "ctrl+alt+shift+k=new_split:up"
          "ctrl+alt+shift+j=new_split:down"
        ];
      };

      systemd.enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
  };

  flake.modules.homeManager.linux-desktop =
    { lib, ... }:
    {
      wayland.windowManager.niri.settings.binds."Mod+Return" = {
        _props.hotkey-overlay-title = "Open a Terminal: ghostty";
        spawn-sh = "ghostty +new-window";
      };

      wayland.windowManager.niri.settings.window-rule = lib.mkAfter [
        {
          match = {
            _props."app-id" = "com.mitchellh.ghostty";
          };

          background-effect.blur = true;
        }
      ];

      xdg.terminal-exec = {
        settings = {
          default = [
            "com.mitchellh.ghostty.desktop"
          ];
        };
      };
    };
}
