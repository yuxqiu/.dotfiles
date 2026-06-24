{
  flake.modules.homeManager.nvim =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      programs.nixvim.plugins.conform-nvim = {
        enable = true;

        settings = {
          format_on_save = ''
            function(bufnr)
              if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                return
              end
              return { timeout_ms = 500, lsp_format = "fallback" }
            end
          '';

        };
      };

      programs.nixvim.extraConfigLua = ''
        vim.api.nvim_create_user_command("FormatDisable", function(args)
          if args.bang then
            vim.b.disable_autoformat = true
          else
            vim.g.disable_autoformat = true
          end
        end, {
          desc = "Disable autoformat-on-save",
          bang = true,
        })
        vim.api.nvim_create_user_command("FormatEnable", function()
          vim.b.disable_autoformat = false
          vim.g.disable_autoformat = false
        end, {
          desc = "Re-enable autoformat-on-save",
        })

        vim.keymap.set("n", "<leader>ufd", "<cmd>FormatDisable<CR>", { desc = "Disable format-on-save" })
        vim.keymap.set("n", "<leader>ufe", "<cmd>FormatEnable<CR>", { desc = "Enable format-on-save" })
      '';
    };
}
