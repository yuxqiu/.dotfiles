{
  flake.modules.homeManager.nvim =
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

        -- Project tracking: record directories opened with nvim (no file args)
        local _project_file = vim.fn.stdpath("data") .. "/nvim-projects"
        local function _project_lines()
          local f = io.open(_project_file, "r")
          if not f then return function() end end
          return f:lines()
        end
        local function _project_add(dir)
          if not dir or dir == "" or not vim.fn.isdirectory(dir) then return end
          dir = vim.fn.fnamemodify(dir, ":p:h")
          if dir == "/tmp" then return end
          local seen = {}
          for line in _project_lines() do
            seen[line] = true
          end
          if seen[dir] then return end
          local f = io.open(_project_file, "a")
          if f then
            f:write(dir .. "\n")
            f:close()
          end
        end
        if vim.fn.argc(-1) == 0 then
          _project_add(vim.fn.getcwd())
        end

        vim.keymap.set("n", "<C-o>", function()
          local pickers = require("telescope.pickers")
          local finders = require("telescope.finders")
          local conf = require("telescope.config").values
          local actions = require("telescope.actions")
          local action_state = require("telescope.actions.state")
          local dirs = {}
          local seen = {}
          for line in _project_lines() do
            if line ~= "" and not seen[line] then
              seen[line] = true
              dirs[#dirs + 1] = line
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
      '';
    };
}
