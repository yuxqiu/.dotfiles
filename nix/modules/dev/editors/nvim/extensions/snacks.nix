{
  flake.modules.homeManager.base =
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
                dim = { enabled = true },
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
                toggle = { enabled = true },
                words = { enabled = true },
                zen = { enabled = true },
              })

              Snacks.dim.enable()

              vim.keymap.set("n", "<leader>uz", function() Snacks.zen.zen() end, { desc = "Toggle Zen mode" })
              vim.keymap.set("n", "<leader>uD", function()
                if Snacks.dim.enabled then
                  Snacks.dim.disable()
                else
                  Snacks.dim.enable()
                end
              end, { desc = "Toggle Dim" })
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
