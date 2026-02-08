{
  flake.modules.homeManager.linux-gui =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        wl-kbptr
        wlrctl
      ];

      xdg.configFile."wl-kbptr/config".text = ''
        # wl-kbptr can be configured with a configuration file.
        # The file location can be passed with the -c parameter.
        # Otherwise the `$XDG_CONFIG_HOME/wl-kbptr/config` file will
        # be loaded if it exits. Below is the default configuration.

        [general]
        home_row_keys=
        cancellation_status_code=0

        [mode_tile]
        label_color=#fffd
        label_select_color=#fd0d
        unselectable_bg_color=#2226
        selectable_bg_color=#0304
        selectable_border_color=#040c
        label_font_family=sans-serif
        label_font_size=8 50% 100
        label_symbols=abcdefghijklmnopqrstuvwxyz

        [mode_floating]
        label_color=#fffd
        label_select_color=#fd0d
        unselectable_bg_color=#2226
        selectable_bg_color=#0018
        selectable_border_color=#040c
        label_font_family=sans-serif
        label_font_size=18 50% 100
        label_symbols=abcdefghijklmnopqrstuvwxyz

        [mode_bisect]
        label_color=#fffd
        label_font_size=20
        label_font_family=sans-serif
        label_padding=12
        pointer_size=20
        pointer_color=#e22d
        unselectable_bg_color=#2226
        even_area_bg_color=#0304
        even_area_border_color=#0408
        odd_area_bg_color=#0034
        odd_area_border_color=#0048
        history_border_color=#3339

        [mode_split]
        pointer_size=20
        pointer_color=#e22d
        bg_color=#2226
        area_bg_color=#11111188
        vertical_color=#8888ffcc
        horizontal_color=#008800cc
        history_border_color=#3339

        [mode_click]
        button=left
      '';

      programs.wlr-which-key.menus.pointer = {
        menu = [
          {
            key = "g";
            desc = "Detect";
            cmd = "wl-kbptr -o modes=floating,click -o mode_floating.source=detect";
          }
          {
            key = "b";
            desc = "Bisect";
            cmd = "wl-kbptr -o modes=tile,bisect,click";
          }
          {
            key = "h";
            desc = "← left";
            cmd = "wlrctl pointer move -10 0";
            keep_open = true;
          }
          {
            key = "j";
            desc = "↓ down";
            cmd = "wlrctl pointer move 0 10";
            keep_open = true;
          }
          {
            key = "k";
            desc = "↑ up";
            cmd = "wlrctl pointer move 0 -10";
            keep_open = true;
          }
          {
            key = "l";
            desc = "→ right";
            cmd = "wlrctl pointer move 10 0";
            keep_open = true;
          }
          {
            key = "s";
            desc = "Click Left";
            cmd = "wlrctl pointer click left";
          }
          {
            key = "d";
            desc = "Click Middle";
            cmd = "wlrctl pointer click middle";
            keep_open = true;
          }
          {
            key = "f";
            desc = "Click Right";
            cmd = "wlrctl pointer click right";
            keep_open = true;
          }
          {
            key = "Up";
            desc = "Scroll ↑";
            cmd = "wlrctl pointer scroll -10 0";
            keep_open = true;
          }
          {
            key = "Down";
            desc = "Scroll ↓";
            cmd = "wlrctl pointer scroll 10 0";
            keep_open = true;
          }
          {
            key = "Left";
            desc = "Scroll ←";
            cmd = "wlrctl pointer scroll 0 -10";
            keep_open = true;
          }
          {
            key = "Right";
            desc = "Scroll →";
            cmd = "wlrctl pointer scroll 0 10";
            keep_open = true;
          }
        ];
      };
    };
}
