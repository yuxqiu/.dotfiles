{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.neovim.plugins = with pkgs.vimPlugins; [
        {
          plugin = trouble-nvim;
          optional = true;
        }
      ];

      programs.neovim.initLua = ''
        local function load_trouble()
          lazy_load("trouble.nvim", nil, function()
            require("trouble").setup({
              modes = {
                diagnostics = { auto_open = false },
                lsp = { win = { type = "split" } },
              },
            })
          end)
        end

        vim.keymap.set("n", "<leader>td", function() load_trouble(); vim.cmd("Trouble diagnostics toggle") end, { desc = "Diagnostics" })
        vim.keymap.set("n", "<leader>tq", function() load_trouble(); vim.cmd("Trouble qflist toggle") end, { desc = "Quickfix list" })
      '';
    };
}