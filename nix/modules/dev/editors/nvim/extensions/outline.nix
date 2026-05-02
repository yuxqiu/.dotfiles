{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.neovim.plugins = with pkgs.vimPlugins; [
        {
          plugin = outline-nvim;
          type = "lua";
          config = ''
            require("outline").setup({
              outline_window = {
                position = "right",
                width = 30,
                auto_close = true,
                show_numbers = true,
                show_relative_numbers = true,
              },
              symbols = {
                icons = {
                  File = { icon = "󰈙" },
                  Module = { icon = "󰆧" },
                  Namespace = { icon = "󰅪" },
                  Package = { icon = "󰏗" },
                  Class = { icon = "󰌗" },
                  Method = { icon = "󰈚" },
                  Property = { icon = "󰜢" },
                  Field = { icon = "󰇽" },
                  Constructor = { icon = "󰆧" },
                  Enum = { icon = "󰈣" },
                  Interface = { icon = "󰥖" },
                  Function = { icon = "󰊕" },
                  Variable = { icon = "󰀫" },
                  Constant = { icon = "󰏿" },
                  String = { icon = "󰀬" },
                  Number = { icon = "󰎠" },
                  Boolean = { icon = "󰨙" },
                  Array = { icon = "󰅪" },
                  Object = { icon = "󰅩" },
                  Key = { icon = "󰌋" },
                  Null = { icon = "󰟢" },
                  EnumMember = { icon = "󰈣" },
                  Struct = { icon = "󰌗" },
                  Event = { icon = "󰉁" },
                  Operator = { icon = "󰆕" },
                  TypeParameter = { icon = "󰊄" },
                },
              },
            })

            vim.keymap.set("n", "<leader>o", "<cmd>Outline<CR>", { desc = "Toggle outline" })
          '';
        }
      ];
    };
}