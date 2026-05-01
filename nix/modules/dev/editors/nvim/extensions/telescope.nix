{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.neovim.plugins = with pkgs.vimPlugins; [
        plenary-nvim
        telescope-fzf-native-nvim

        {
          plugin = telescope-nvim;
          type = "lua";
          config = ''
            local builtin = require("telescope.builtin")
            require("telescope").setup({
              defaults = {
                file_ignore_patterns = { "%.git/", "node_modules" },
              },
              pickers = {
                find_files = { hidden = true },
              },
            })

            vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "Find files" })
            vim.keymap.set("n", "<C-S-p>", "<cmd>Telescope commands<CR>", { desc = "Command palette" })
            vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
            vim.keymap.set("n", "<leader>fg", function()
              builtin.live_grep({ search_dirs = { vim.fn.getcwd() } })
            end, { desc = "Grep in project" })
            vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
            vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
            vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "Recent files" })
            vim.keymap.set("n", "<leader>fc", builtin.commands, { desc = "Commands" })
            vim.keymap.set("n", "<leader>fr", builtin.resume, { desc = "Resume last picker" })
          '';
        }
      ];

      programs.neovim.initLua = ''
        vim.keymap.set("n", "<C-f>", "/", { desc = "Search in file" })
        vim.keymap.set("n", "<C-S-F>", function()
          require("telescope.builtin").live_grep({ search_dirs = { vim.fn.getcwd() } })
        end, { desc = "Search in project" })
        vim.keymap.set("n", "<C-o>", function()
          local pickers = require("telescope.pickers")
          local finders = require("telescope.finders")
          local conf = require("telescope.config").values
          local actions = require("telescope.actions")
          local action_state = require("telescope.actions.state")
          local dirs = {}
          for _, b in ipairs(vim.v.oldfiles) do
            local dir = vim.fn.fnamemodify(b, ":h")
            if vim.fn.isdirectory(dir) == 1 then
              local root = vim.fn.systemlist("git -C " .. vim.fn.shellescape(dir) .. " rev-parse --show-toplevel 2>/dev/null")[1]
              if root and root ~= "" and vim.fn.isdirectory(root) == 1 and not vim.tbl_contains(dirs, root) then
                dirs[#dirs + 1] = root
              end
            end
          end
          pickers.new({}, {
            prompt_title = "Recent Projects",
            finder = finders.new_table({ results = dirs }),
            sorter = conf.generic_sorter({}),
            attach_mappings = function(bufnr, map)
              actions.select_default:replace(function()
                local dir = action_state.get_selected_entry()[1]
                actions.close(bufnr)
                vim.fn.chdir(dir)
                require("neo-tree.command").execute({ source_name = "filesystem", action = "focus", dir = dir })
                require("telescope.builtin").find_files({ cwd = dir })
              end)
              return true
            end,
          }):find()
        end, { desc = "Recent projects" })
        vim.keymap.set("n", "<C-S-p>", "<cmd>Telescope commands<CR>", { desc = "Command palette" })
      '';
    };
}
