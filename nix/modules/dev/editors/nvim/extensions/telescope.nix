{
  flake.modules.homeManager.nvim =
    { pkgs, ... }:
    {
      programs.nixvim = {
        plugins.telescope = {
          enable = true;
          lazyLoad.settings.cmd = [ "Telescope" ];
          keymaps = {
            "<C-p>" = {
              action = "find_files";
              options.desc = "Find files";
            };
            "<leader>fb" = {
              action = "buffers";
              options.desc = "Find buffers";
            };
            "<leader>fh" = {
              action = "help_tags";
              options.desc = "Help tags";
            };
            "<leader>fo" = {
              action = "oldfiles";
              options.desc = "Recent files";
            };
            "<leader>fc" = {
              action = "commands";
              options.desc = "Commands";
            };
            "<leader>fr" = {
              action = "resume";
              options.desc = "Resume last picker";
            };
          };
          settings = {
            defaults = {
              vimgrep_arguments = [
                "${pkgs.ripgrep}/bin/rg"
                "-L"
                "--color=never"
                "--no-heading"
                "--with-filename"
                "--line-number"
                "--column"
                "--smart-case"
                "--fixed-strings"
              ];
              file_ignore_patterns = [
                "%.git/"
                "node_modules"
              ];
            };
            pickers = {
              find_files.hidden = true;
            };
          };
        };

        plugins.telescope.extensions.fzf-native.enable = true;

        keymaps = [
          {
            key = "<C-f>";
            action = "/";
            options.desc = "Search in file";
          }
        ];

        extraConfigLua = ''
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
            require('lz.n').trigger_load('telescope.nvim')
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
    };
}
