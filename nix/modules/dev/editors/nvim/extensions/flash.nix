{
  flake.modules.homeManager.nvim = {
    programs.nixvim.plugins.flash = {
      enable = true;
      settings.modes.char = {
        enabled = true;
        autohide = true;
        multi_line = false;
      };
    };

    programs.nixvim.keymaps = [
      {
        mode = [
          "n"
          "x"
          "o"
        ];
        key = "f";
        action.__raw = ''function() require("flash").jump() end'';
        options.desc = "Flash";
      }
      {
        mode = [
          "n"
          "x"
          "o"
        ];
        key = "F";
        action.__raw = ''function() require("flash").treesitter() end'';
        options.desc = "Flash Treesitter";
      }
    ];
  };
}
