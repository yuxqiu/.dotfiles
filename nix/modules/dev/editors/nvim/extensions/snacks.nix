{
  flake.modules.homeManager.nvim =
    { pkgs, ... }:
    {
      programs.neovim = {
        extraPackages = with pkgs; [
          imagemagick
        ];
        plugins = with pkgs.vimPlugins; [
          {
            plugin = snacks-nvim;
            type = "lua";
            config = ''
              require("snacks").setup({
                bigfile = { enabled = true },
                dashboard = {
                  enabled = true,
                  sections = {
                    { section = "header" },
                    { section = "keys", gap = 1, padding = 1 },
                    { section = "recent_files", icon = " ", title = "Recent Files", cwd = true, limit = 5, padding = 1 },
                    { section = "projects", icon = " ", title = "Projects", limit = 3, padding = 1 },
                  },
                  preset = {
                    keys = {
                      { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
                      { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
                      { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
                      { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
                    },
                  },
                },
                git = { enabled = true },
                gitbrowse = { enabled = true },
                image = { enabled = true },
                indent = {
                  enabled = true,
                  char = "▏",
                  scope = { enabled = true, show_start = false, show_end = false },
                },
                input = { enabled = true },
                notifier = { enabled = false },
                quickfile = { enabled = true },
                scope = { enabled = true },
                scroll = { enabled = true },
                statuscolumn = { enabled = true },
                terminal = { enabled = true, interactive = false, start_insert = true, auto_close = true, win = { enter = true, wo = { winbar = "" } } },
                toggle = { enabled = true },
                words = { enabled = true },
                zen = { enabled = true },
              })

              vim.api.nvim_set_hl(0, "SnacksNormal", { link = "Normal" })
              vim.api.nvim_set_hl(0, "SnacksNormalNC", { link = "Normal" })

              local _orig_fixbuf = Snacks.win.fixbuf
              Snacks.win.fixbuf = function(self)
                local saved_win = self.win
                _orig_fixbuf(self)
                if saved_win and vim.api.nvim_win_is_valid(saved_win) then
                  local cur = vim.api.nvim_get_current_win()
                  if cur == saved_win then
                    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
                      local win_buf = vim.api.nvim_win_get_buf(win)
                      if win ~= saved_win and vim.api.nvim_win_get_config(win).zindex == nil then
                        if vim.bo[win_buf].buftype == "" then
                          local target = win
                          vim.schedule(function() vim.api.nvim_set_current_win(target) vim.cmd("stopinsert") end)
                          return
                        end
                      end
                    end
                  end
                end
              end

              vim.keymap.set("t", "<C-`>", function() Snacks.terminal.toggle() end, { desc = "Toggle last terminal" })
              vim.keymap.set("n", "<C-`>", function() Snacks.terminal.toggle() end, { desc = "Toggle last terminal" })

              for i = 1, 9 do
                vim.keymap.set("n", "<leader>t" .. i, function() Snacks.terminal.toggle(nil, { count = i }) end, { desc = "Toggle terminal " .. i })
              end

              local function term_picker()
                local terms = Snacks.terminal.list()
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
                  local name = vim.b[term.buf].term_title or "shell"
                  local id = vim.b[term.buf].snacks_terminal and vim.b[term.buf].snacks_terminal.id or "?"
                  table.insert(entries, { term = term, display = "#" .. id .. " " .. name })
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
                      if selection then selection.value.term:focus() end
                    end)
                    return true
                  end,
                }):find()
              end
              vim.keymap.set("n", "<leader>tt", term_picker, { desc = "Terminal picker" })

              vim.keymap.set("n", "<leader>uz", function() Snacks.zen.zen() end, { desc = "Toggle Zen mode" })
              vim.keymap.set("n", "<leader>gb", function() Snacks.gitbrowse.open() end, { desc = "Git browse" })
              vim.keymap.set("n", "<leader>gl", function() Snacks.git.blame_line() end, { desc = "Git blame line" })

              vim.keymap.set("n", "]]", function() Snacks.words.jump(vim.v.count1) end, { desc = "Next Reference" })
              vim.keymap.set("n", "[[", function() Snacks.words.jump(-vim.v.count1) end, { desc = "Prev Reference" })
            '';
          }
        ];
      };
    };
}
