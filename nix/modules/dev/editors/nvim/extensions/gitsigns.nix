{
  flake.modules.homeManager.nvim = {
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
    '';

    programs.nixvim.keymaps = [
      {
        key = "<leader>gi";
        action.__raw = ''
          function()
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
          end
        '';
        options.desc = "Toggle inline git diff";
      }
      {
        key = "<leader>gd";
        action.__raw = ''function() require("gitsigns").diffthis() end'';
        options.desc = "Git diff (side-by-side)";
      }
      {
        key = "<leader>gD";
        action.__raw = ''function() require("gitsigns").diffthis("~") end'';
        options.desc = "Git diff against last commit (side-by-side)";
      }
      {
        key = "<leader>gn";
        action.__raw = ''
          function()
            if vim.wo.diff then
              vim.cmd.normal({ "]c", bang = true })
            else
              require("gitsigns").nav_hunk("next")
            end
          end
        '';
        options.desc = "Next hunk";
      }
      {
        key = "<leader>gp";
        action.__raw = ''
          function()
            if vim.wo.diff then
              vim.cmd.normal({ "[c", bang = true })
            else
              require("gitsigns").nav_hunk("prev")
            end
          end
        '';
        options.desc = "Previous hunk";
      }
      {
        key = "<leader>gs";
        action.__raw = ''function() require("gitsigns").stage_hunk() end'';
        options.desc = "Stage hunk";
      }
      {
        key = "<leader>gr";
        action.__raw = ''function() require("gitsigns").reset_hunk() end'';
        options.desc = "Restore hunk";
      }
      {
        key = "<leader>gu";
        action.__raw = ''function() require("gitsigns").undo_stage_hunk() end'';
        options.desc = "Unstage hunk";
      }
    ];
  };
}
