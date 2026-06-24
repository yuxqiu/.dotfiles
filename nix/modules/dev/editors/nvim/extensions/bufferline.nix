{
  flake.modules.homeManager.nvim =
    { pkgs, ... }:
    {
      programs.nixvim = {
        plugins.mini-bufremove.enable = true;
        plugins.bufferline = {
          enable = true;
          settings = {
            options = {
              diagnostics = "nvim_lsp";
              show_buffer_close_icons = true;
              show_close_icon = false;
              separator_style = "thin";
              close_command.__raw = ''
                function(bufnr)
                  require("mini.bufremove").delete(bufnr)
                end
              '';
              right_mouse_command.__raw = ''
                function(bufnr)
                  require("mini.bufremove").delete(bufnr)
                end
              '';
              offsets = [
                {
                  filetype = "neo-tree";
                  text = "File Explorer";
                  padding = 1;
                }
                {
                  filetype = "snacks_terminal";
                  text = "Terminal";
                  padding = 1;
                }
              ];
            };
            highlights.__raw = ''require("catppuccin.special.bufferline").get_theme()'';
          };
        };

        extraConfigLua = ''
          vim.keymap.set("n", "<C-Tab>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
          vim.keymap.set("n", "<C-S-Tab>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Prev buffer" })
          vim.keymap.set("n", "<C-w>", function() require("mini.bufremove").delete() end, { desc = "Close buffer" })
        '';
      };
    };
}
