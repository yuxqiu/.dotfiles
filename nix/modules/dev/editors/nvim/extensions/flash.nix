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
        key = "s";
        action.__raw = ''function() require("flash").jump() end'';
        options.desc = "Flash";
      }
      {
        mode = [
          "n"
          "x"
          "o"
        ];
        key = "S";
        action.__raw = ''function() require("flash").treesitter() end'';
        options.desc = "Flash Treesitter";
      }
      {
        mode = "o";
        key = "r";
        action.__raw = ''function() require("flash").remote() end'';
        options.desc = "Flash Remote";
      }
    ];
  };
}
