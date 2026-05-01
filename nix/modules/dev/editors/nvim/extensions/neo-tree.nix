{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.neovim.plugins = with pkgs.vimPlugins; [
        {
          plugin = neo-tree-nvim;
          type = "lua";
          config = ''
            require("neo-tree").setup({
              close_if_last_window = true,
              filesystem = {
                follow_current_file = { enabled = true },
                use_libuv_file_watcher = true,
                filtered_items = { visible = true, hide_dotfiles = false, hide_gitignored = false },
                window = {
                  mappings = {
                    ["n"] = "add",
                    ["N"] = "add_directory",
                    ["d"] = "delete",
                    ["r"] = "rename",
                    ["h"] = "navigate_up",
                    ["l"] = "open",
                    ["<C-b>"] = "close_window",
                    ["<C-S-e>"] = function(state)
                      vim.cmd("wincmd p")
                    end,
                  },
                },
              },
              git_status = { window = { position = "float" } },
              source_selector = { winbar = true, sources = { { source = "filesystem" }, { source = "git_status" } } },
            })

            vim.keymap.set("n", "<C-b>", "<cmd>Neotree toggle<CR>", { desc = "Toggle file explorer" })

            vim.keymap.set("n", "<C-S-e>", function()
              if vim.bo.filetype == "neo-tree" then
                vim.cmd("wincmd p")
              else
                vim.cmd("Neotree focus")
              end
            end, { desc = "Toggle focus between explorer and editor" })
          '';
        }
      ];
    };
}
