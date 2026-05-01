{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.neovim.plugins = with pkgs.vimPlugins; [
        nvim-navic

        {
          plugin = lualine-nvim;
          type = "lua";
          config = ''
            local navic = require("nvim-navic")
            require("lualine").setup({
              options = {
                theme = "catppuccin-mocha",
                globalstatus = true,
              },
              sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch", "diff", "diagnostics" },
                lualine_c = {
                  { "filename", path = 1 },
                  { navic.get_location, cond = navic.is_available },
                },
                lualine_x = { "encoding", "fileformat", "filetype" },
                lualine_y = { "progress" },
                lualine_z = { "location" },
              },
            })
          '';
        }
      ];
    };
}
