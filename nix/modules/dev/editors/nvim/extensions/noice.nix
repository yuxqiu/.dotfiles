{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.neovim.plugins = with pkgs.vimPlugins; [
        nui-nvim
        nvim-notify

        {
          plugin = noice-nvim;
          type = "lua";
          config = ''
            require("noice").setup({
              lsp = {
                override = {
                  ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                  ["vim.lsp.util.stylize_markdown"] = true,
                  ["cmp.entry.get_documentation"] = true,
                },
              },
              presets = {
                bottom_search = true,
                command_palette = true,
                long_message_to_split = true,
                inc_rename = true,
                lsp_doc_border = true,
              },
              views = {
                cmdline_popup = {
                  border = { style = "rounded" },
                  position = { row = 5, col = "50%" },
                  size = { width = 60, height = "auto" },
                },
                popupmenu = {
                  border = { style = "rounded" },
                  position = { row = 8, col = "50%" },
                  size = { width = 60, height = "auto" },
                },
              },
              routes = {
                {
                  view = "notify",
                  filter = { event = "notify" },
                  opts = { replace = true },
                },
                {
                  filter = {
                    event = "msg_show",
                    kind = { "", "echo", "echomsg" },
                  },
                  opts = { skip = true },
                },
                {
                  filter = { event = "msg_show" },
                  view = "mini",
                },
              },
            })

              vim.keymap.set("n", "<leader>sn", function() require("noice").cmd("last") end, { desc = "Noice last" })
              vim.keymap.set("n", "<leader>sN", function() require("noice").cmd("history") end, { desc = "Noice history" })
          '';
        }
      ];
    };
}
