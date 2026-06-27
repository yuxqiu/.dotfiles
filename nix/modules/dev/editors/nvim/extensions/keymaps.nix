{
  flake.modules.homeManager.nvim = {
    programs.nixvim.extraConfigLua = ''
      -- Keymaps
      vim.keymap.set("n", "<C-=>", function() change_font_size(1) end, { desc = "Increase font size" })
      vim.keymap.set("n", "<C-+>", function() change_font_size(1) end, { desc = "Increase font size" })
      vim.keymap.set("n", "<C-->", function() change_font_size(-1) end, { desc = "Decrease font size" })
      vim.keymap.set("n", "<C-n>", "<cmd>enew<CR>", { desc = "New file" })

      -- Terminal mode: <Esc> to enter normal mode
      vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

      -- Insert mode: VSCode-style
      vim.keymap.set("i", "<C-s>", "<Esc>:w<CR>", { desc = "Save file" })
      vim.keymap.set("n", "<C-s>", "<cmd>w<CR>", { desc = "Save file" })
      vim.keymap.set("v", "<C-s>", "<Esc>:w<CR>", { desc = "Save file" })

      -- Disable default q (macro recording) to prevent accidental hijack of leader key
      vim.keymap.set("n", "q", "<Nop>", { noremap = true })
      vim.keymap.set("n", "<leader>Qr", "q", { desc = "Record macro", noremap = true })
      vim.keymap.set("n", "<leader>Qp", "@", { desc = "Play macro", noremap = true })
      vim.keymap.set("n", "<leader>Ql", "@@", { desc = "Play last macro", noremap = true })

      -- Quick move to line start/end
      vim.keymap.set({ "n", "x", "o" }, "H", "^", { noremap = true })
      vim.keymap.set({ "n", "x", "o" }, "L", "$", { noremap = true })

      -- Movement: hjkl + arrows move by display line (wrap-aware)
      vim.keymap.set({ "n", "x", "o" }, "j", "gj", { desc = "Down (wrap-aware)" })
      vim.keymap.set({ "n", "x", "o" }, "k", "gk", { desc = "Up (wrap-aware)" })
      vim.keymap.set({ "n", "x", "o" }, "<Down>", "gj", { desc = "Down (wrap-aware)" })
      vim.keymap.set({ "n", "x", "o" }, "<Up>", "gk", { desc = "Up (wrap-aware)" })
      vim.keymap.set("i", "<Down>", "<C-o>gj", { desc = "Down (wrap-aware)" })
      vim.keymap.set("i", "<Up>", "<C-o>gk", { desc = "Up (wrap-aware)" })

      -- Clipboard
      vim.keymap.set("n", "Y", '"+y', { noremap = true })
      vim.keymap.set("v", "Y", '"+y', { noremap = true })

      -- Jump list navigation (back/forward like Zed)
      vim.keymap.set("n", "<leader>jb", "<C-O>", { desc = "Jump back" })
      vim.keymap.set("n", "<leader>jf", "<C-I>", { desc = "Jump forward" })

      -- Toggle relative line numbers (from Zed vim config)
      vim.keymap.set("n", "<leader>lr", "<cmd>set relativenumber!<CR>", { desc = "Toggle relative line numbers" })
    '';
  };
}
