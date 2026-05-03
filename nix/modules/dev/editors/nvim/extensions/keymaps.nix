{
  flake.modules.homeManager.base = {
    programs.neovim.initLua = ''
      -- General settings
      vim.opt.encoding = "utf-8"
      vim.opt.hidden = true
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.showmatch = true
      vim.opt.shiftwidth = 4
      vim.opt.tabstop = 4
      vim.opt.expandtab = true
      vim.opt.smarttab = true
      vim.opt.formatoptions = "croqln"
      vim.opt.backup = false
      vim.opt.writebackup = false
      vim.opt.wrap = false
      vim.opt.ignorecase = true
      vim.opt.smartcase = true
      vim.opt.hlsearch = true
      vim.opt.mouse = "a"
      vim.opt.wildmode = { "longest", "list" }
      vim.opt.wildmenu = true
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.opt.foldcolumn = "1"
      vim.opt.foldnestmax = 10
      vim.opt.foldenable = false
      vim.opt.foldlevel = 99
      vim.opt.autoindent = true
      vim.opt.cursorline = true
      vim.opt.signcolumn = "yes"
      vim.opt.splitbelow = true
      vim.opt.splitright = true
      vim.opt.updatetime = 250
      vim.opt.timeoutlen = 300
      vim.opt.scrolloff = 8
      vim.opt.sidescrolloff = 8
      vim.opt.termguicolors = true
      vim.opt.clipboard = "unnamedplus"
      vim.opt.showtabline = 2
      vim.opt.laststatus = 3
      vim.opt.pumheight = 10
      vim.opt.inccommand = "split"
      vim.opt.diffopt:append("algorithm:histogram")

      -- Font size adjustment
      local function change_font_size(delta)
        local guifont = vim.o.guifont
        if guifont == "" then return end
        local size = tonumber(guifont:match(":h(%d+)$")) or 12
        local new_size = math.max(6, size + delta)
        local base = guifont:gsub(":h%d+$", "")
        vim.o.guifont = base .. ":h" .. new_size
      end

      -- Keymaps
      vim.keymap.set("n", "<C-=>", function() change_font_size(1) end, { desc = "Increase font size" })
      vim.keymap.set("n", "<C-+>", function() change_font_size(1) end, { desc = "Increase font size" })
      vim.keymap.set("n", "<C-->", function() change_font_size(-1) end, { desc = "Decrease font size" })
      vim.keymap.set("n", "<C-n>", "<cmd>enew<CR>", { desc = "New file" })

      -- Split commands
      vim.api.nvim_create_user_command("SplitVertical", "vsplit", { desc = "Split window vertically" })
      vim.api.nvim_create_user_command("SplitHorizontal", "split", { desc = "Split window horizontally" })
      vim.api.nvim_create_user_command("SplitClose", "close", { desc = "Close current split" })
      vim.api.nvim_create_user_command("SplitCloseOthers", "only", { desc = "Close other splits" })
      vim.api.nvim_create_user_command("SplitFocusRight", "wincmd l", { desc = "Move focus to right split" })
      vim.api.nvim_create_user_command("SplitFocusLeft", "wincmd h", { desc = "Move focus to left split" })
      vim.api.nvim_create_user_command("SplitFocusUp", "wincmd k", { desc = "Move focus to upper split" })
      vim.api.nvim_create_user_command("SplitFocusDown", "wincmd j", { desc = "Move focus to lower split" })
      vim.api.nvim_create_user_command("NewFile", "new", { desc = "New unnamed file" })
      vim.keymap.set("n", "<leader>sv", "<cmd>vsplit<CR>", { desc = "Split vertically" })
      vim.keymap.set("n", "<leader>sh", "<cmd>split<CR>", { desc = "Split horizontally" })
      vim.keymap.set("n", "<leader>sc", "<cmd>close<CR>", { desc = "Close split" })
      vim.keymap.set("n", "<leader>so", "<cmd>only<CR>", { desc = "Close other splits" })
      vim.keymap.set("n", "<leader>sJ", "<C-w>j", { desc = "Focus split below" })
      vim.keymap.set("n", "<leader>sK", "<C-w>k", { desc = "Focus split above" })
      vim.keymap.set("n", "<leader>sL", "<C-w>l", { desc = "Focus split right" })
      vim.keymap.set("n", "<leader>sH", "<C-w>h", { desc = "Focus split left" })
      vim.keymap.set("n", "<leader>ss", function()
        vim.notify("[RESIZE] ←→/h/l: width  ↑↓/j/k: height  Esc: exit", vim.log.levels.INFO)
        local actions = {
          ["h"]      = "vertical resize -2",
          ["l"]      = "vertical resize +2",
          ["j"]      = "resize -2",
          ["k"]      = "resize +2",
          ["\x1b[D"] = "vertical resize -2",
          ["\x1b[C"] = "vertical resize +2",
          ["\x1b[B"] = "resize -2",
          ["\x1b[A"] = "resize +2",
        }
        while true do
          local ok, c = pcall(vim.fn.getcharstr)
          if not ok then break end
          if c == "\27" or c == "q" then break end
          if actions[c] then vim.cmd(actions[c]) end
          vim.cmd("redraw!")
        end
      end, { desc = "Resize split (sticky)" })
      vim.keymap.set("n", "<leader>s<Up>", "<C-w>+", { desc = "Increase split height" })
      vim.keymap.set("n", "<leader>s<Down>", "<C-w>-", { desc = "Decrease split height" })
      vim.keymap.set("n", "<leader>s<Right>", "<C-w>>", { desc = "Increase split width" })
      vim.keymap.set("n", "<leader>s<Left>", "<C-w><", { desc = "Decrease split width" })

      -- Terminal navigation
      vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Move to left window" })
      vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Move to below window" })
      vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Move to above window" })
      vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Move to right window" })

      -- Insert mode: VSCode-style
      vim.keymap.set("i", "<C-s>", "<Esc>:w<CR>", { desc = "Save file" })
      vim.keymap.set("n", "<C-s>", "<cmd>w<CR>", { desc = "Save file" })
      vim.keymap.set("v", "<C-s>", "<Esc>:w<CR>", { desc = "Save file" })

      -- Ctrl+Shift+J/K: move lines (from Zed)
      vim.keymap.set("n", "<C-S-j>", "<cmd>m .+1<CR>==", { desc = "Move line down" })
      vim.keymap.set("n", "<C-S-k>", "<cmd>m .-2<CR>==", { desc = "Move line up" })
      vim.keymap.set("v", "<C-S-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
      vim.keymap.set("v", "<C-S-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

      -- Insert mode: Ctrl+Backspace to delete word backward
      vim.keymap.set("i", "<C-BS>", "<C-W>", { noremap = true })

      -- Shift+Tab to de-indent in insert mode (undo tab)
      vim.keymap.set("i", "<S-Tab>", "<C-D>", { noremap = true })

      -- Quick move to line start/end
      vim.keymap.set("n", "H", "^", { noremap = true })
      vim.keymap.set("n", "L", "$", { noremap = true })

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
