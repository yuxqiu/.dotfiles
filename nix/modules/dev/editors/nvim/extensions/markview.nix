{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.neovim.plugins = with pkgs.vimPlugins; [
        {
          plugin = markview-nvim;
          type = "lua";
          config = ''
            require("markview").setup({
              preview = {
                enable = true,
                filetypes = { "markdown", "typst", "latex" },
                hybrid_modes = { "n" },
              },
            })

            vim.keymap.set("n", "<leader>um", function() require("markview.commands").toggle() end, { desc = "Toggle markview" })
          '';
        }
      ];
    };
}