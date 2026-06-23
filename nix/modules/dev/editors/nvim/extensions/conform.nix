{
  flake.modules.homeManager.nvim =
    { pkgs, config, lib, ... }:
    let
      formattersByFt = lib.flatten (lib.mapAttrsToList (_: lang:
        lib.optional (lang.formatter != null) {
          ft = lang.formatter.filetypes;
          formatter = lang.formatter.cmd;
        }
      ) config.my.dev.languages);

      formattersLua = lib.concatMapStringsSep "\n    " (entry:
        lib.concatMapStringsSep "\n    " (ft:
          ''${ft} = { "${entry.formatter}" },''
        ) entry.ft
      ) formattersByFt;
    in
    {
      programs.neovim.plugins = with pkgs.vimPlugins; [
        {
          plugin = conform-nvim;
          type = "lua";
          config = ''
            require("conform").setup({
              format_on_save = function(bufnr)
                -- Disable with a global or buffer-local variable
                if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                  return
                end
                return { timeout_ms = 500, lsp_format = "fallback" }
              end,
              formatters_by_ft = {
                ${formattersLua}
              },
            })

            vim.api.nvim_create_user_command("FormatDisable", function(args)
              if args.bang then
                -- FormatDisable! will disable formatting just for this buffer
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
        }
      ];
    };
}
