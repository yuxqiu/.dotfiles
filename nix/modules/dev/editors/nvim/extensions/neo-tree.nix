{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.neovim.plugins = with pkgs.vimPlugins; [
        {
          plugin = neo-tree-nvim;
          type = "lua";
          config = ''
            local neotree_width = 40

            require("neo-tree").setup({
              close_if_last_window = true,
              open_on_start = false,
              filesystem = {
                follow_current_file = { enabled = true },
                use_libuv_file_watcher = true,
                filtered_items = { visible = true, hide_dotfiles = false, hide_gitignored = false },
                window = {
                  width = function()
                    return neotree_width
                  end,
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
              event_handlers = {
                {
                  event = "neo_tree_window_before_close",
                  handler = function(args)
                    neotree_width = vim.api.nvim_win_get_width(args.winid)
                  end,
                },
              },
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

