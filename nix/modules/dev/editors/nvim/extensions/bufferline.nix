{
  flake.modules.homeManager.nvim =
    { pkgs, ... }:
    {
      programs.neovim.plugins = with pkgs.vimPlugins; [
        {
          plugin = mini-bufremove;
          type = "lua";
          config = ''
            require("mini.bufremove").setup()
          '';
        }
        {
          plugin = bufferline-nvim;
          type = "lua";
          config = ''
            require("bufferline").setup({
              options = {
                diagnostics = "nvim_lsp",
                show_buffer_close_icons = true,
                show_close_icon = false,
                separator_style = "thin",
                close_command = function(bufnr)
                  require("mini.bufremove").delete(bufnr)
                end,
                right_mouse_command = function(bufnr)
                  require("mini.bufremove").delete(bufnr)
                end,
                offsets = {
                  { filetype = "neo-tree", text = "File Explorer", padding = 1 },
                  { filetype = "toggleterm", text = "Terminal", padding = 1 },
                },
              },
            })
          '';
        }
      ];

      programs.neovim.initLua = ''
        vim.keymap.set("n", "<C-Tab>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
        vim.keymap.set("n", "<C-S-Tab>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Prev buffer" })
        vim.keymap.set("n", "<C-w>", function() require("mini.bufremove").delete() end, { desc = "Close buffer" })
      '';
    };
}
