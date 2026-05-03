{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.neovim.plugins = with pkgs.vimPlugins; [
        {
          plugin = markview-nvim;
          optional = true;
        }
      ];

      programs.neovim.initLua = ''
        local function load_markview()
          lazy_load("markview.nvim", nil, function()
            require("markview").setup({
              preview = {
                enable = true,
                filetypes = { "markdown", "typst", "latex" },
                hybrid_modes = { "n" },
              },
            })
          end)
        end

        vim.keymap.set("n", "<leader>um", function() load_markview(); require("markview.commands").toggle() end, { desc = "Toggle markview" })
        vim.api.nvim_create_autocmd("FileType", {
          pattern = { "markdown", "typst", "latex" },
          callback = function() load_markview() end,
        })
      '';
    };
}