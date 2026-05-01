{
  flake.modules.homeManager.base = {
    programs.neovim.initLua = ''
      -- Leader
      vim.g.mapleader = " "

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
      vim.keymap.set("n", "<C-n>", "<cmd>new<CR>", { desc = "New file" })

      -- LSP keymaps
      vim.keymap.set("n", "<C-.>", require("fastaction").code_action, { desc = "Code Action" })
      vim.keymap.set("x", "<leader>ca", require("fastaction").code_action, { desc = "Code Action" })
      vim.keymap.set("n", "<leader>ca", require("fastaction").code_action, { desc = "Code Action" })

      vim.keymap.set("n", "<2-LeftMouse>", function()
        local lenses = vim.lsp.codelens.get({ bufnr = 0 })
        if #lenses > 0 then
          vim.lsp.codelens.run()
        else
          vim.fn.execute("normal! \\<2-LeftMouse>")
        end
      end, { desc = "Click code lens or default double-click" })
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Goto Definition" })
      vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "References" })
      vim.keymap.set("n", "gI", vim.lsp.buf.implementation, { desc = "Goto Implementation" })
      vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, { desc = "Goto T[y]pe Definition" })
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Goto Declaration" })
      vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, { desc = "Hover" })
      vim.keymap.set("n", "gK", function() vim.lsp.buf.signature_help() end, { desc = "Signature Help" })
      vim.keymap.set("i", "<C-k>", function() vim.lsp.buf.signature_help() end, { desc = "Signature Help" })
      vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })
      vim.keymap.set("n", "<leader>cc", vim.lsp.codelens.run, { desc = "Run Codelens" })
      vim.keymap.set("n", "<leader>cC", vim.lsp.codelens.refresh, { desc = "Refresh Codelens" })
      vim.keymap.set("n", "<leader>cl", "<cmd>lua vim.lsp.log.set_level('debug')<CR>", { desc = "LSP Log" })

      -- Snacks.words: navigate LSP references
      vim.keymap.set("n", "]]", function() Snacks.words.jump(vim.v.count1) end, { desc = "Next Reference" })
      vim.keymap.set("n", "[[", function() Snacks.words.jump(-vim.v.count1) end, { desc = "Prev Reference" })

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

      -- Window navigation
      vim.keymap.set("n", "<C-j>", "<cmd>lua vim.diagnostic.goto_next()<CR>", { desc = "Next diagnostic" })
      vim.keymap.set("n", "<C-k>", "<cmd>lua vim.diagnostic.goto_prev()<CR>", { desc = "Prev diagnostic" })

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

      -- Toggle relative line numbers (from Zed vim config)
      vim.keymap.set("n", "<leader>lr", "<cmd>set relativenumber!<CR>", { desc = "Toggle relative line numbers" })
    '';
  };
}
