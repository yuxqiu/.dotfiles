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

            local function mark_terminal_win(buf)
              for _, win in ipairs(vim.fn.win_findbuf(buf)) do
                vim.w[win]._was_terminal = buf
              end
            end

            vim.api.nvim_create_autocmd({ "TermOpen", "BufEnter" }, {
              callback = function()
                local cur_win = vim.api.nvim_get_current_win()
                local cur_buf = vim.api.nvim_win_get_buf(cur_win)
                local cur_ft = vim.bo[cur_buf].filetype
                local cur_bt = vim.bo[cur_buf].buftype
                if cur_ft == "toggleterm" or cur_bt == "terminal" then
                  vim.w[cur_win]._was_terminal = cur_buf
                  return
                end
                local term_buf = vim.w[cur_win]._was_terminal
                if not term_buf then return end
                vim.w[cur_win]._was_terminal = nil
                if not vim.api.nvim_buf_is_valid(term_buf) then return end
                local term_bt = vim.bo[term_buf].buftype
                local term_ft = vim.bo[term_buf].filetype
                if term_ft ~= "toggleterm" and term_bt ~= "terminal" then return end
                local wins = vim.tbl_filter(function(w)
                  local w_buf = vim.api.nvim_win_get_buf(w)
                  local w_bt = vim.bo[w_buf].buftype
                  local w_ft = vim.bo[w_buf].filetype
                  return w ~= cur_win
                    and not vim.api.nvim_win_get_config(w).zindex
                    and w_ft ~= "toggleterm"
                    and w_bt ~= "terminal"
                end, vim.api.nvim_tabpage_list_wins(vim.api.nvim_get_current_tabpage()))
                if #wins == 0 then return end
                vim.api.nvim_win_set_buf(wins[1], cur_buf)
                vim.api.nvim_win_set_buf(cur_win, term_buf)
                vim.api.nvim_set_current_win(wins[1])
              end,
            })

            vim.api.nvim_create_autocmd("OptionSet", {
              pattern = "buftype",
              callback = function()
                if vim.v.option_new == "terminal" then
                  mark_terminal_win(vim.api.nvim_get_current_buf())
                end
              end,
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
