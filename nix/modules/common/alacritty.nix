{ config, pkgs, ... }:

{
  programs.alacritty = {
    enable = true;

    settings = {
      colors = {
        cursor = {
          cursor = "#528bff";
          text = "CellBackground";
        };

        normal = {
          black = "#5c6370";
          blue = "#61afef";
          cyan = "#56b6c2";
          green = "#98c379";
          magenta = "#c678dd";
          red = "#e06c75";
          white = "#828997";
          yellow = "#e5c07b";
        };

        primary = {
          background = "#282c34";
          foreground = "#abb2bf";
        };

        selection = {
          background = "#3e4451";
          text = "CellForeground";
        };
      };

      env = { TERM = "xterm-256color"; };

      font = { size = 12.0; };

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

      general = { live_config_reload = true; };
    };

    package = (config.lib.nixGL.wrap pkgs.alacritty);
  };
}
