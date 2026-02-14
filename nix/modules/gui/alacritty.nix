{
  flake.modules.homeManager.desktop = {
    programs.alacritty = {
      enable = true;

      settings = {
        env = {
          TERM = "xterm-256color";
        };

        scrolling = {
          history = 10000;
          multiplier = 3;
        };

        window = {
          dynamic_padding = false;
          opacity = 1.0;
          dimensions = {
            columns = 120;
            lines = 30;
          };
          padding = {
            x = 10;
            y = 23;
          };
        };

        general = {
          live_config_reload = true;
        };
      };
    };
  };

  flake.modules.homeManager.linux-base = {
    xdg.terminal-exec = {
      settings = {
        default = [
          "Alacritty.desktop"
        ];
      };
    };
  };
}
