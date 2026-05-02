{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.neovim.plugins = with pkgs.vimPlugins; [
        {
          plugin = flash-nvim;
          type = "lua";
          config = ''
            require("flash").setup({
              modes = {
                char = {
                  enabled = true,
                  autohide = true,
                  multi_line = false,
                },
              },
            })

            vim.keymap.set({ "n", "x", "o" }, "s", "<cmd>Flash<CR>", { desc = "Flash" })
            vim.keymap.set({ "n", "x", "o" }, "S", "<cmd>FlashTreesitter<CR>", { desc = "Flash Treesitter" })
            vim.keymap.set("o", "r", "<cmd>FlashRemote<CR>", { desc = "Flash Remote" })
          '';
        }

        {
          plugin = comment-nvim;
          type = "lua";
          config = ''
            require("Comment").setup({
              padding = true,
              sticky = true,
            })

            vim.keymap.set("n", "<C-/>", "<Plug>(comment_toggle_linewise_current)", { desc = "Toggle comment" })
            vim.keymap.set("v", "<C-/>", "<Plug>(comment_toggle_linewise_visual)", { desc = "Toggle comment" })
            vim.keymap.set("i", "<C-/>", "<Esc><Plug>(comment_toggle_linewise_current)A", { desc = "Toggle comment" })
          '';
        }

        {
          plugin = nvim-autopairs;
          type = "lua";
          config = ''
            require("nvim-autopairs").setup({
              check_ts = true,
              ts_config = { lua = { "string", "source" }, javascript = { "string", "template_string" } },
              disable_filetype = { "TelescopePrompt", "spectre_panel", "grug-far" },
              fast_wrap = {
                map = "<M-e>",
                chars = { "{", "[", "(", '"', "'" },
                pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s", ""),
                end_key = "$",
                keys = "qwertyuiopzxcvbnmasdfghjkl",
                check_comma = true,
                highlight = "Search",
                highlight_grey = "Comment",
              },
            })
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            local cmp = require("cmp")
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
          '';
        }
      ];
    };
}
