{
  flake.modules.homeManager.base =
    { pkgs, config, ... }:
    let
      lspPkgs = config.my.dev.lsp;
    in
    {
      programs.neovim = {
        enable = true;
        viAlias = true;
        vimAlias = true;

        plugins = with pkgs.vimPlugins; [
          nvim-treesitter
          nvim-treesitter-parsers.bash
          nvim-treesitter-parsers.c
          nvim-treesitter-parsers.cpp
          nvim-treesitter-parsers.go
          nvim-treesitter-parsers.json
          nvim-treesitter-parsers.lua
          nvim-treesitter-parsers.markdown
          nvim-treesitter-parsers.markdown_inline
          nvim-treesitter-parsers.nix
          nvim-treesitter-parsers.python
          nvim-treesitter-parsers.rust
          nvim-treesitter-parsers.scss
          nvim-treesitter-parsers.toml
          nvim-treesitter-parsers.typst
          nvim-treesitter-parsers.vim
          nvim-treesitter-parsers.vimdoc
          nvim-treesitter-parsers.yaml

          {
            plugin = catppuccin-nvim;
            type = "lua";
            config = ''
              vim.cmd.colorscheme("catppuccin-mocha")
            '';
          }

          {
            plugin = nvim-lspconfig;
            type = "lua";
            config = ''
              local capabilities = require("cmp_nvim_lsp").default_capabilities()
              capabilities.textDocument.completion.completionItem.snippetSupport = true
              capabilities.textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }

              -- File extensions to disable inlay hints
              local inlay_hint_exclude = {}

              local on_attach = function(client, bufnr)
                if client.server_capabilities.documentSymbolProvider then
                  require("nvim-navic").attach(client, bufnr)
                end
                local ft = vim.bo[bufnr].filetype
                if not inlay_hint_exclude[ft] then
                  vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
                end
                if client.server_capabilities.foldingRangeProvider then
                  local win = vim.api.nvim_get_current_win()
                  vim.wo[win].foldexpr = "v:lua.vim.lsp.foldexpr()"
                end
                if client.server_capabilities.codeLensProvider then
                  vim.lsp.codelens.enable(true, { bufnr = bufnr })
                end
              end

              vim.lsp.config("basedpyright", { capabilities = capabilities, on_attach = on_attach })
              vim.lsp.config("clangd", { capabilities = capabilities, on_attach = on_attach })
              vim.lsp.config("gopls", { capabilities = capabilities, on_attach = on_attach })
              vim.lsp.config("markdown_oxide", { capabilities = capabilities, on_attach = on_attach })
              vim.lsp.config("nixd", { capabilities = capabilities, on_attach = on_attach })
              vim.lsp.config("ruff", { capabilities = capabilities, on_attach = on_attach })
              vim.lsp.config("tinymist", {
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                  exportPdf = "onSave",
                  formatterMode = "typstyle",
                },
              })
              vim.lsp.config("texlab", {
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                  texlab = {
                    build = {
                      onSave = true,
                      forwardSearchAfter = true,
                      executable = "tectonic",
                      args = {
                        "-X", "compile", "%f",
                        "--untrusted", "--synctex",
                        "--keep-logs", "--keep-intermediates",
                      },
                    },
                  },
                },
              })
              vim.lsp.config("jsonls", { capabilities = capabilities, on_attach = on_attach })
              vim.lsp.config("typos_lsp", { capabilities = capabilities, on_attach = on_attach })
              vim.lsp.config("bashls", { capabilities = capabilities, on_attach = on_attach })
              vim.lsp.config("cssls", { capabilities = capabilities, on_attach = on_attach })
              vim.lsp.config("lua_ls", { capabilities = capabilities, on_attach = on_attach })
              vim.lsp.config("rust_analyzer", { capabilities = capabilities, on_attach = on_attach })
              vim.lsp.config("taplo", { capabilities = capabilities, on_attach = on_attach })
              vim.lsp.config("yamlls", { capabilities = capabilities, on_attach = on_attach })

              vim.lsp.enable({
                "basedpyright",
                "bashls",
                "clangd",
                "cssls",
                "gopls",
                "jsonls",
                "lua_ls",
                "markdown_oxide",
                "nixd",
                "ruff",
                "rust_analyzer",
                "taplo",
                "tinymist",
                "texlab",
                "typos_lsp",
                "yamlls",
              })

              vim.diagnostic.config({
                virtual_text = true,
                severity_sort = true,
                underline = true,
                signs = true,
                float = {
                  border = "rounded",
                  source = "always",
                },
              })
            '';
          }

          {
            plugin = conform-nvim;
            type = "lua";
            config = ''
              require("conform").setup({
                format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
                formatters_by_ft = {
                  nix = { "nixfmt" },
                  python = { "ruff" },
                  bib = { "latexindent" },
                },
              })
            '';
          }

          {
            plugin = nvim-cmp;
            type = "lua";
            config = ''
              local cmp = require("cmp")
              local luasnip = require("luasnip")

              require("luasnip.loaders.from_vscode").lazy_load()

              cmp.setup({
                snippet = {
                  expand = function(args)
                    luasnip.lsp_expand(args.body)
                  end,
                },
                mapping = cmp.mapping.preset.insert({
                  ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                  ["<C-f>"] = cmp.mapping.scroll_docs(4),
                  ["<C-Space>"] = cmp.mapping.complete(),
                  ["<C-e>"] = cmp.mapping.abort(),
                  ["<CR>"] = cmp.mapping.confirm({ select = false }),
                  ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                      cmp.select_next_item()
                    elseif luasnip.expand_or_jumpable() then
                      luasnip.expand_or_jump()
                    else
                      fallback()
                    end
                  end, { "i", "s" }),
                  ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                      cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                      luasnip.jump(-1)
                    else
                      fallback()
                    end
                  end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                  { name = "nvim_lsp" },
                  { name = "luasnip" },
                }, {
                  { name = "buffer" },
                  { name = "path" },
                }),
              })

              cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                  { name = "path" },
                }, {
                  { name = "cmdline" },
                }),
              })
            '';
          }
          cmp-nvim-lsp
          cmp-buffer
          cmp-path
          cmp-cmdline
          luasnip
          friendly-snippets

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
          plenary-nvim
          telescope-fzf-native-nvim

          {
            plugin = neo-tree-nvim;
            type = "lua";
            config = ''
              require("neo-tree").setup({
                close_if_last_window = true,
                filesystem = {
                  follow_current_file = { enabled = true },
                  use_libuv_file_watcher = true,
                  filtered_items = { visible = true, hide_dotfiles = false, hide_gitignored = false },
                  window = {
                    mappings = {
                      ["n"] = "add",
                      ["N"] = "add_directory",
                      ["d"] = "delete",
                      ["r"] = "rename",
                      ["h"] = "navigate_up",
                      ["l"] = "open",
                      ["<C-b>"] = "close_window",
                      ["<C-S-e>"] = function(state)
                        vim.cmd("wincmd p")
                      end,
                    },
                  },
                },
                git_status = { window = { position = "float" } },
                source_selector = { winbar = true, sources = { { source = "filesystem" }, { source = "git_status" } } },
              })

              vim.keymap.set("n", "<C-b>", "<cmd>Neotree toggle<CR>", { desc = "Toggle file explorer" })

              vim.keymap.set("n", "<C-S-e>", function()
                if vim.bo.filetype == "neo-tree" then
                  vim.cmd("wincmd p")
                else
                  vim.cmd("Neotree focus")
                end
              end, { desc = "Toggle focus between explorer and editor" })
            '';
          }

          {
            plugin = bufferline-nvim;
            type = "lua";
            config = ''
              _G.smart_close = function(bufnr)
                bufnr = tonumber(bufnr) or vim.api.nvim_get_current_buf()
                if vim.bo[bufnr].modified then
                  local choice = vim.fn.confirm("Save changes?", "&Save\n&Discard\n&Cancel", 1)
                  if choice == 1 then
                    vim.cmd("write")
                  elseif choice == 2 then
                    vim.bo[bufnr].modified = false
                  else
                    return
                  end
                end
                local listed = vim.tbl_filter(function(b)
                  return vim.bo[b].buflisted and b ~= bufnr
                end, vim.api.nvim_list_bufs())
                if #listed == 0 then
                  vim.cmd("new")
                  vim.cmd("bdelete! " .. bufnr)
                else
                  vim.cmd("buffer " .. listed[#listed])
                  vim.cmd("bdelete! " .. bufnr)
                end
              end

              require("bufferline").setup({
                options = {
                  diagnostics = "nvim_lsp",
                  show_buffer_close_icons = true,
                  show_close_icon = false,
                  separator_style = "thin",
                  close_command = _G.smart_close,
                  right_mouse_command = _G.smart_close,
                  offsets = {
                    { filetype = "neo-tree", text = "File Explorer", padding = 1 },
                    { filetype = "toggleterm", text = "Terminal", padding = 1 },
                  },
                },
              })

              -- Re-apply close commands after bufferline overrides them
              vim.schedule(function()
                local opts = require("bufferline.config").options
                opts.close_command = _G.smart_close
                opts.right_mouse_command = _G.smart_close
              end)
              vim.keymap.set("n", "<C-Tab>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
              vim.keymap.set("n", "<C-S-Tab>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Prev buffer" })
            '';
          }

          {
            plugin = toggleterm-nvim;
            type = "lua";
            config = ''
              require("toggleterm").setup({
                size = function(term)
                  if term.direction == "horizontal" then
                    return 15
                  elseif term.direction == "vertical" then
                    return math.floor(vim.o.columns * 0.4)
                  end
                end,
                direction = "horizontal",
                open_mapping = [[<c-`>]],
                insert_mappings = true,
                terminal_mappings = true,
                float_opts = { border = "curved" },
              })

              vim.keymap.set("t", "<C-`>", "<cmd>ToggleTerm<CR>", { desc = "Toggle terminal" })
              vim.keymap.set("n", "<C-`>", "<cmd>ToggleTerm<CR>", { desc = "Toggle terminal" })
              vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
            '';
          }

          {
            plugin = lualine-nvim;
            type = "lua";
            config = ''
              local navic = require("nvim-navic")
              require("lualine").setup({
                options = {
                  theme = "catppuccin-mocha",
                  globalstatus = true,
                },
                sections = {
                  lualine_a = { "mode" },
                  lualine_b = { "branch", "diff", "diagnostics" },
                  lualine_c = {
                    { "filename", path = 1 },
                    { navic.get_location, cond = navic.is_available },
                  },
                  lualine_x = { "encoding", "fileformat", "filetype" },
                  lualine_y = { "progress" },
                  lualine_z = { "location" },
                },
              })
            '';
          }
          nvim-navic

          {
            plugin = which-key-nvim;
            type = "lua";
            config = ''
              require("which-key").setup({
                replace = {
                  ["<leader>"] = "SPC",
                  ["<cr>"] = "RET",
                  ["<tab>"] = "TAB",
                },
              })
            '';
          }

          {
            plugin = gitsigns-nvim;
            type = "lua";
            config = ''
              require("gitsigns").setup({
                signs = {
                  add = { text = "▎" },
                  change = { text = "▎" },
                  delete = { text = "" },
                  topdelete = { text = "" },
                  changedelete = { text = "▎" },
                  untracked = { text = "▎" },
                },
                signs_staged = {
                  add = { text = "▎" },
                  change = { text = "▎" },
                  delete = { text = "" },
                  topdelete = { text = "" },
                  changedelete = { text = "▎" },
                },
                current_line_blame = true,
                current_line_blame_opts = {
                  virt_text = true,
                  virt_text_pos = "eol",
                  delay = 300,
                },
                current_line_blame_formatter = " <author>, <author_time:%Y-%m-%d> - <summary>",
                word_diff = false,
              })
            '';
          }

          {
            plugin = leap-nvim;
            type = "lua";
            config = ''
              vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap)")
              vim.keymap.set("n", "S", "<Plug>(leap-from-window)")
            '';
          }

          {
            plugin = comment-nvim;
            type = "lua";
            config = ''
              require("Comment").setup()
            '';
          }

          {
            plugin = nvim-autopairs;
            type = "lua";
            config = ''
              require("nvim-autopairs").setup({
                check_ts = true,
                ts_config = { lua = { "string", "source" }, javascript = { "string", "template_string" } },
                disable_filetype = { "TelescopePrompt", "spectre_panel" },
                fast_wrap = {
                  map = "<M-e>",
                  chars = { "{", "[", "(", '"', "'" },
                  pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s", ""),
                  end_key = "$",
                  keys = "qwertyuiopzxcvbnmasdfghjkl",
                  check_comma = true,
                  highlight = "Search",
                  highlight_grey = "Comment",
                },
              })
              local cmp_autopairs = require("nvim-autopairs.completion.cmp")
              local cmp = require("cmp")
              cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
            '';
          }

          markdown-preview-nvim

          {
            plugin = typst-vim;
            type = "lua";
            config = ''
              vim.g.typst_auto_compile = 0
              vim.g.typst_pdf_viewer = "sioyek"
            '';
          }

          {
            plugin = typst-preview-nvim;
            type = "lua";
            config = ''
              require("typst-preview").setup({
                dependent_binaries = { "tinymist" },
              })
            '';
          }

          {
            plugin = vimtex;
            type = "lua";
            config = ''
              vim.g.vimtex_view_method = "sioyek"
              vim.g.vimtex_compiler_method = "tectonic"
              vim.g.vimtex_compiler_tectonic = {
                options = { "--synctex", "--keep-logs", "--keep-intermediates" },
              }
              vim.g.tex_flavor = "latex"
              vim.g.vimtex_quickfix_mode = 2
            '';
          }

          editorconfig-vim

          {
            plugin = nvim-dap;
            type = "lua";
            config = ''
              local dap = require("dap")
              vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Continue" })
              vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Debug: Step over" })
              vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Debug: Step into" })
              vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Debug: Step out" })
              vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
            '';
          }

          {
            plugin = nvim-dap-ui;
            type = "lua";
            config = ''
              require("dapui").setup()
              local dap, dapui = require("dap"), require("dapui")
              dap.listeners.after.event_initialized["dapui_config"] = dapui.open
              dap.listeners.before.event_terminated["dapui_config"] = dapui.close
              dap.listeners.before.event_exited["dapui_config"] = dapui.close
              vim.keymap.set("n", "<leader>du", require("dapui").toggle, { desc = "Toggle DAP UI" })
            '';
          }
          {
            plugin = nvim-dap-virtual-text;
            type = "lua";
            config = ''
              require("nvim-dap-virtual-text").setup()
            '';
          }

          {
            plugin = todo-comments-nvim;
            type = "lua";
            config = ''
              require("todo-comments").setup()
            '';
          }

          nvim-web-devicons

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
                    { section = "recent_files", icon = " ", title = "Recent Files", cwd = true, limit = 5, padding = 1 },
                    { section = "projects", icon = " ", title = "Projects", limit = 3, padding = 1 },
                  },
                  preset = {
                    keys = {
                      { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
                      { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
                      { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
                      { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
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
                notifier = { enabled = true },
                quickfile = { enabled = true },
                scope = { enabled = true },
                scroll = { enabled = true },
                statuscolumn = { enabled = true },
                toggle = { enabled = true },
                words = { enabled = true },
                zen = { enabled = true },
              })

              vim.keymap.set("n", "<leader>z", function() Snacks.zen.zen() end, { desc = "Toggle Zen mode" })
              vim.keymap.set("n", "<leader>gb", function() Snacks.gitbrowse.open() end, { desc = "Git browse" })
              vim.keymap.set("n", "<leader>gl", function() Snacks.git.blame_line() end, { desc = "Git blame line" })
            '';
          }

          {
            plugin = fastaction-nvim;
            type = "lua";
            config = ''
              require("fastaction").setup({
                popup = {
                  border = "rounded",
                },
              })
            '';
          }

          {
            plugin = dressing-nvim;
            type = "lua";
            config = ''
              require("dressing").setup({
                select = {
                  enabled = true,
                  backend = { "fzf_lua", "telescope", "fzf", "builtin" },
                },
              })
            '';
          }

          {
            plugin = trouble-nvim;
            type = "lua";
            config = ''
              require("trouble").setup({
                modes = {
                  diagnostics = { auto_open = false },
                  lsp = { win = { type = "split" } },
                },
              })
              vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", { desc = "Diagnostics" })
              vim.keymap.set("n", "<leader>xq", "<cmd>Trouble qflist toggle<CR>", { desc = "Quickfix list" })
            '';
          }

          {
            plugin = nvim-hlslens;
            type = "lua";
            config = ''
              require("hlslens").setup({})
            '';
          }

          {
            plugin = nvim-scrollbar;
            type = "lua";
            config = ''
              require("scrollbar").setup({
                handlers = {
                  diagnostic = true,
                  gitsigns = true,
                  search = true,
                },
              })
            '';
          }

          {
            plugin = nvim-lint;
            type = "lua";
            config = ''
              local lint = require("lint")
              lint.linters_by_ft = {
                bash = { "shellcheck" },
                c = { "clangtidy" },
                cpp = { "clangtidy" },
                go = { "golangcilint" },
                nix = { "deadnix", "statix" },
                python = { "ruff" },
                rust = { "clippy" },
                sh = { "shellcheck" },
                yaml = { "yamllint" },
              }

              vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
                callback = function()
                  lint.try_lint()
                end,
              })
            '';
          }
        ];

        extraPackages =
          lspPkgs
          ++ (with pkgs; [
            ripgrep
            fd
          ]);

        initLua = ''
          -- VSCode-specific: minimal setup for vscode-neovim
          if vim.g.vscode then
            vim.keymap.set('x', 'gc', '<Plug>VSCodeCommentary', {})
            vim.keymap.set('n', 'gc', '<Plug>VSCodeCommentary', {})
            vim.keymap.set('o', 'gc', '<Plug>VSCodeCommentary', {})
            vim.keymap.set('n', 'gcc', '<Plug>VSCodeCommentaryLine', {})
            vim.keymap.set('n', 'zc', '<Cmd>call VSCodeNotify("editor.fold")<CR>', { noremap = true })
            vim.keymap.set('n', 'zC', '<Cmd>call VSCodeNotify("editor.foldRecursively")<CR>', { noremap = true })
            vim.keymap.set('n', 'zo', '<Cmd>call VSCodeNotify("editor.unfold")<CR>', { noremap = true })
            vim.keymap.set('n', 'zO', '<Cmd>call VSCodeNotify("editor.unfoldRecursively")<CR>', { noremap = true })
            return
          end

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

          -- Keymaps (VSCode-style in normal mode)
          vim.keymap.set("n", "<C-S-p>", "<cmd>Telescope commands<CR>", { desc = "Command palette" })
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
          vim.keymap.set("n", "<C-=>", function() change_font_size(1) end, { desc = "Increase font size" })
          vim.keymap.set("n", "<C-+>", function() change_font_size(1) end, { desc = "Increase font size" })
          vim.keymap.set("n", "<C-->", function() change_font_size(-1) end, { desc = "Decrease font size" })

          -- New file (like VSCode Ctrl+N: opens unnamed buffer)
          vim.keymap.set("n", "<C-n>", "<cmd>enew<CR>", { desc = "New file" })

          vim.keymap.set("n", "<C-w>", function() _G.smart_close() end, { desc = "Close buffer" })

          -- LSP keymaps
          vim.keymap.set("n", "<C-.>", require("fastaction").code_action, { desc = "Code Action" })
          vim.keymap.set("x", "<leader>ca", require("fastaction").code_action, { desc = "Code Action" })
          vim.keymap.set("n", "<leader>ca", require("fastaction").code_action, { desc = "Code Action" })
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
          vim.api.nvim_create_user_command("SplitVertical", "vsplit", { desc = "Split window vertically" })
          vim.api.nvim_create_user_command("SplitHorizontal", "split", { desc = "Split window horizontally" })
          vim.api.nvim_create_user_command("SplitClose", "close", { desc = "Close current split" })
          vim.api.nvim_create_user_command("SplitCloseOthers", "only", { desc = "Close other splits" })
          vim.api.nvim_create_user_command("SplitFocusRight", "wincmd l", { desc = "Move focus to right split" })
          vim.api.nvim_create_user_command("SplitFocusLeft", "wincmd h", { desc = "Move focus to left split" })
          vim.api.nvim_create_user_command("SplitFocusUp", "wincmd k", { desc = "Move focus to upper split" })
          vim.api.nvim_create_user_command("SplitFocusDown", "wincmd j", { desc = "Move focus to lower split" })
          vim.api.nvim_create_user_command("NewFile", "enew", { desc = "New unnamed file" })
          vim.keymap.set("n", "<leader>sv", "<cmd>vsplit<CR>", { desc = "Split vertically" })
          vim.keymap.set("n", "<leader>sh", "<cmd>split<CR>", { desc = "Split horizontally" })
          vim.keymap.set("n", "<leader>sc", "<cmd>close<CR>", { desc = "Close split" })
          vim.keymap.set("n", "<leader>so", "<cmd>only<CR>", { desc = "Close other splits" })

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

          -- Quick move to line start/end
          vim.keymap.set("n", "H", "^", { noremap = true })
          vim.keymap.set("n", "L", "$", { noremap = true })

          -- Clipboard
          vim.keymap.set("n", "Y", '"+y', { noremap = true })
          vim.keymap.set("v", "Y", '"+y', { noremap = true })

          -- Toggle relative line numbers (from Zed vim config)
          vim.keymap.set("n", "<leader>lr", "<cmd>set relativenumber!<CR>", { desc = "Toggle relative line numbers" })

          -- Format on save via LSP fallback
          vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = true }),
            callback = function(args)
              local client = vim.lsp.get_client_by_id(args.data.client_id)
              if client and client.server_capabilities.documentFormattingProvider then
                vim.api.nvim_create_autocmd("BufWritePre", {
                  buffer = args.buf,
                  callback = function()
                    vim.lsp.buf.format({ async = false, bufnr = args.buf })
                  end,
                })
              end
            end,
          })

          -- Soft wrap for Typst and LaTeX (from Zed config)
          vim.api.nvim_create_autocmd("FileType", {
            pattern = { "typst", "tex", "latex" },
            callback = function()
              vim.opt_local.wrap = true
              vim.opt_local.linebreak = true
            end,
          })
        '';
      };

      home.sessionVariables = {
        EDITOR = "${pkgs.neovim}/bin/nvim";
        VISUAL = "${pkgs.neovim}/bin/nvim";
      };

      stylix.targets.neovim.transparentBackground.main = true;
      stylix.targets.neovim.transparentBackground.numberLine = true;
      stylix.targets.neovim.transparentBackground.signColumn = true;
    };

  flake.modules.homeManager.desktop = {
    xdg.mimeApps = {
      associations.added = {
        "text/markdown" = [ "nvim.desktop" ];
        "text/x-tex" = [ "nvim.desktop" ];
        "text/x-typst" = [ "nvim.desktop" ];
      };
      defaultApplications = {
        "text/markdown" = [ "nvim.desktop" ];
        "text/x-tex" = [ "nvim.desktop" ];
        "text/x-typst" = [ "nvim.desktop" ];
      };
    };
  };
}
