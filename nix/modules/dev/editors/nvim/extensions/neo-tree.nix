{
  flake.modules.homeManager.nvim =
    { pkgs, ... }:
    {
      programs.neovim.plugins = with pkgs.vimPlugins; [
        {
          plugin = nvim-window-picker;
          type = "lua";
          config = ''
            require("window-picker").setup()
          '';
        }
        {
          plugin = neo-tree-nvim;
          type = "lua";
          config = ''
            local neotree_width = 30

            local sources = { "filesystem", "git_status", "document_symbols" }

            local cycle_source = function(state)
              local current = state.name
              local idx = nil
              for i, s in ipairs(sources) do
                if s == current then
                  idx = i
                  break
                end
              end
              local next = idx and sources[(idx % #sources) + 1] or "filesystem"
              vim.cmd("Neotree source=" .. next)
            end

            require("neo-tree").setup({
              close_if_last_window = true,
              open_on_start = false,
              sources = sources,
              source_selector = {
                winbar = true,
                sources = {
                  { source = "filesystem" },
                  { source = "git_status" },
                  { source = "document_symbols" },
                },
              },
              default_component_configs = {
                indent = { with_expanders = true },
              },
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
                  },
                },
              },
              git_status = {
                window = {
                  width = function()
                    return neotree_width
                  end,
                },
              },
              document_symbols = {
                follow_cursor = true,
                renderers = {
                  symbol = {
                    { "indent", with_expanders = true },
                    { "kind_icon", default = "?" },
                    { "name", zindex = 10 },
                  },
                },
                window = {
                  width = function()
                    return neotree_width
                  end,
                  mappings = {
                    ["<CR>"] = "open",
                    ["l"] = "open",
                    ["h"] = "close_node",
                  },
                },
              },
              window = {
                mappings = {
                  ["<C-r>"] = "none",
                  ["<C-b>"] = "close_window",
                  ["<C-S-e>"] = function(state)
                    vim.cmd("wincmd p")
                  end,
                  ["<Tab>"] = cycle_source,
                  ["L"] = "expand_all_nodes",
                },
              },
              event_handlers = {
                {
                  event = "neo_tree_window_before_close",
                  handler = function(args)
                    neotree_width = vim.api.nvim_win_get_width(args.winid)
                  end,
                },
              },
            })

            vim.keymap.set("n", "<C-b>", "<cmd>Neotree toggle last<CR>", { desc = "Toggle file explorer" })

            vim.keymap.set("n", "<C-S-e>", function()
              if vim.bo.filetype == "neo-tree" then
                vim.cmd("wincmd p")
              else
                vim.cmd("Neotree focus last")
              end
            end, { desc = "Toggle focus between explorer and editor" })
          '';
        }
      ];
    };
}
