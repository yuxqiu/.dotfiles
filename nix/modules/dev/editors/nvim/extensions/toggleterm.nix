{
  flake.modules.homeManager.nvim =
    { pkgs, ... }:
    {
      programs.neovim.plugins = with pkgs.vimPlugins; [
        {
          plugin = toggleterm-nvim;
          type = "lua";
          config = ''
            local function get_term_title(term)
              local buf = term.bufnr
              if not buf or not vim.api.nvim_buf_is_valid(buf) then return term.display_name or "shell" end
              local pid = vim.b[buf].terminal_job_pid
              if pid then
                local children = vim.api.nvim_get_proc_children(pid)
                if children and #children > 0 then
                  local child = vim.api.nvim_get_proc(children[#children])
                  if child and child.name and child.name ~= "" then return child.name end
                end
                local proc = vim.api.nvim_get_proc(pid)
                if proc and proc.name and proc.name ~= "" then return proc.name end
              end
              local title = vim.b[buf].term_title
              if type(title) == "string" and title ~= "" then return title end
              return term.display_name or vim.fn.fnamemodify(term.cmd or "", ":t") or "shell"
            end

            require("toggleterm").setup({
              size = function(term)
                if term.direction == "horizontal" then
                  return 15
                elseif term.direction == "vertical" then
                  return math.floor(vim.o.columns * 0.4)
                end
              end,
              direction = "horizontal",
              open_mapping = nil,
              insert_mappings = true,
              terminal_mappings = true,
              float_opts = { border = "curved" },
              shade_terminals = false,
            })


            vim.keymap.set("t", "<C-`>", "<cmd>ToggleTerm<CR>", { desc = "Toggle last terminal" })
            vim.keymap.set("n", "<C-`>", "<cmd>ToggleTerm<CR>", { desc = "Toggle last terminal" })
            vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

            for i = 1, 9 do
              vim.keymap.set("n", "<leader>t" .. i, "<cmd>" .. i .. "ToggleTerm<CR>", { desc = "Toggle terminal " .. i })
              vim.keymap.set("t", "<leader>t" .. i, "<cmd>" .. i .. "ToggleTerm<CR>", { desc = "Toggle terminal " .. i })
            end

            local function term_picker()
              local terms = require("toggleterm.terminal").get_all()
              if #terms == 0 then
                vim.notify("No terminals", vim.log.levels.INFO)
                return
              end
              local pickers = require("telescope.pickers")
              local finders = require("telescope.finders")
              local conf = require("telescope.config").values
              local actions = require("telescope.actions")
              local action_state = require("telescope.actions.state")
              local entries = {}
              for _, term in ipairs(terms) do
                local name = get_term_title(term)
                local status = term:is_open() and "open" or "hidden"
                table.insert(entries, { id = term.id, display = "#" .. term.id .. " " .. name .. " [" .. status .. "]" })
              end
              pickers.new({}, {
                prompt_title = "Terminals",
                finder = finders.new_table({
                  results = entries,
                  entry_maker = function(entry)
                    return { value = entry, display = entry.display, ordinal = entry.display }
                  end,
                }),
                sorter = conf.generic_sorter({}),
                attach_mappings = function(bufnr, _)
                  actions.select_default:replace(function()
                    local selection = action_state.get_selected_entry()
                    actions.close(bufnr)
                    if selection then vim.cmd(selection.value.id .. "ToggleTerm") end
                  end)
                  return true
                end,
              }):find()
            end
            vim.keymap.set("n", "<leader>tt", term_picker, { desc = "Terminal picker" })
            vim.keymap.set("t", "<leader>tt", term_picker, { desc = "Terminal picker" })
          '';
        }
      ];
    };
}
