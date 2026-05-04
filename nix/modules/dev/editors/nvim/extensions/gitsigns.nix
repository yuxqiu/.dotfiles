{
  flake.modules.homeManager.nvim =
    { pkgs, ... }:
    {
      programs.neovim.plugins = with pkgs.vimPlugins; [
        {
          plugin = gitsigns-nvim;
          type = "lua";
          config = ''
            require("gitsigns").setup({
              signs = {
                add = { text = "▎" },
                change = { text = "▎" },
                delete = { text = "" },
                topdelete = { text = "" },
                changedelete = { text = "▎" },
                untracked = { text = "▎" },
              },
              signs_staged = {
                add = { text = "▎" },
                change = { text = "▎" },
                delete = { text = "" },
                topdelete = { text = "" },
                changedelete = { text = "▎" },
              },
              current_line_blame = true,
              current_line_blame_opts = {
                virt_text = true,
                virt_text_pos = "eol",
                delay = 300,
              },
              current_line_blame_formatter = " <author>, <author_time:%Y-%m-%d> - <summary>",
              word_diff = false,
            })

            local gitsigns_inline_diff = false
            vim.keymap.set("n", "<leader>gd", function()
              gitsigns_inline_diff = not gitsigns_inline_diff
              if gitsigns_inline_diff then
                require("gitsigns").toggle_linehl(true)
                require("gitsigns").toggle_deleted(true)
                require("gitsigns").toggle_word_diff(true)
              else
                require("gitsigns").toggle_linehl(false)
                require("gitsigns").toggle_deleted(false)
                require("gitsigns").toggle_word_diff(false)
              end
            end, { desc = "Toggle inline git diff" })

            vim.keymap.set("n", "<leader>gs", function()
              require("gitsigns").stage_hunk()
            end, { desc = "Stage hunk" })

            vim.keymap.set("n", "<leader>gr", function()
              require("gitsigns").reset_hunk()
            end, { desc = "Restore hunk" })

            vim.keymap.set("n", "<leader>gu", function()
              require("gitsigns").undo_stage_hunk()
            end, { desc = "Unstage hunk" })
          '';
        }
      ];
    };
}
