{
  flake.modules.homeManager.nvim =
    { pkgs, ... }:
    {
      programs.nixvim.plugins.gitsigns = {
        enable = true;
        settings = {
          signs = {
            add.text = "▎";
            change.text = "▎";
            delete.text = "";
            topdelete.text = "";
            changedelete.text = "▎";
            untracked.text = "▎";
          };
          signs_staged = {
            add.text = "▎";
            change.text = "▎";
            delete.text = "";
            topdelete.text = "";
            changedelete.text = "▎";
          };
          current_line_blame = true;
          current_line_blame_opts = {
            virt_text = true;
            virt_text_pos = "eol";
            delay = 300;
          };
          current_line_blame_formatter = " <author>, <author_time:%Y-%m-%d> - <summary>";
          word_diff = false;
        };
      };

      programs.nixvim.extraConfigLua = ''
        local gitsigns_inline_diff = false
        vim.keymap.set("n", "<leader>gi", function()
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

        vim.keymap.set("n", "<leader>gd", function()
          require("gitsigns").diffthis()
        end, { desc = "Git diff (side-by-side)" })

        vim.keymap.set("n", "<leader>gD", function()
          require("gitsigns").diffthis("~")
        end, { desc = "Git diff against last commit (side-by-side)" })

        vim.keymap.set("n", "<leader>gn", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            require("gitsigns").nav_hunk("next")
          end
        end, { desc = "Next hunk" })

        vim.keymap.set("n", "<leader>gp", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            require("gitsigns").nav_hunk("prev")
          end
        end, { desc = "Previous hunk" })

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
    };
}
