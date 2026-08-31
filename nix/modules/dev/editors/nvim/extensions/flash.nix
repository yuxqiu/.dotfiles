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
        action.__raw = ''
          function()
            require("flash").jump({
              search = {
                ---@param str string
                mode = function(str)
                  local prefix = str:match("^(.-)  +$")
                  if prefix then
                    return require("flash.search.pattern")._exact(prefix) .. "\\(  \\|\\$\\)"
                  end
                  return require("flash.search.pattern")._exact(str)
                end,
              },
            })
          end
        '';
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
