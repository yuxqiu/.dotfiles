{
  flake.modules.homeManager.linux-gui = {
    imports = [ ./_wlr_which_key.nix ];

    programs.wlr-which-key = {
      enable = true;

      settings = {
        background = "#282828d0";
        color = "#fbf1c7";
        border = "#8ec07c";
        separator = " ➜ ";
        border_width = 2;
        corner_r = 10;
        padding = 15;
        rows_per_column = 5;
        column_padding = 25;
        anchor = "center";
        inhibit_compositor_keyboard_shortcuts = true;
        auto_kbd_layout = true;
      };
    };
  };
}
