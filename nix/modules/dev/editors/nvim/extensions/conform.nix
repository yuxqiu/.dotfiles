{
  flake.modules.homeManager.nvim = {
    programs.nixvim.plugins.conform-nvim = {
      enable = true;

      settings = {
        format_on_save.__raw = ''
          function(bufnr)
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
              return
            end
            return { timeout_ms = 500, lsp_format = "fallback" }
          end
        '';
      };
    };

    programs.nixvim.userCommands = {
      FormatDisable = {
        command.__raw = ''
          function(args)
            if args.bang then
              vim.b.disable_autoformat = true
            else
              vim.g.disable_autoformat = true
            end
          end
        '';
        bang = true;
        desc = "Disable autoformat-on-save";
      };
      FormatEnable = {
        command.__raw = ''
          function()
            vim.b.disable_autoformat = false
            vim.g.disable_autoformat = false
          end
        '';
        desc = "Re-enable autoformat-on-save";
      };
    };

    programs.nixvim.keymaps = [
      {
        key = "<leader>ufd";
        action = "<cmd>FormatDisable<CR>";
        options.desc = "Disable format-on-save";
      }
      {
        key = "<leader>ufe";
        action = "<cmd>FormatEnable<CR>";
        options.desc = "Enable format-on-save";
      }
    ];
  };
}
