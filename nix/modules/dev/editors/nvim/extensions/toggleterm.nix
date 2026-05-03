{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.neovim.plugins = with pkgs.vimPlugins; [
        {
          plugin = toggleterm-nvim;
          type = "lua";
          config = ''
            require("toggleterm").setup({
              size = function(term)
                if term.direction == "horizontal" then
                  return 15
                elseif term.direction == "vertical" then
                  return math.floor(vim.o.columns * 0.4)
                end
              end,
              direction = "horizontal",
              open_mapping = [[<c-`>]],
              insert_mappings = true,
              terminal_mappings = true,
              float_opts = { border = "curved" },
              shade_terminals = false,
            })

            vim.keymap.set("t", "<C-`>", "<cmd>ToggleTerm<CR>", { desc = "Toggle terminal" })
            vim.keymap.set("n", "<C-`>", "<cmd>ToggleTerm<CR>", { desc = "Toggle terminal" })
            vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
          '';
        }
      ];
    };
}
