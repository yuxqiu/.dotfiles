{
  flake.modules.homeManager.nvim =
    { pkgs, ... }:
    {
      programs.neovim.plugins = with pkgs.vimPlugins; [
        nvim-ts-context-commentstring

        {
          plugin = flash-nvim;
          type = "lua";
          config = ''
            require("flash").setup({
              modes = {
                char = {
                  enabled = true,
                  autohide = true,
                  multi_line = false,
                },
              },
            })

            vim.keymap.set({ "n", "x", "o" }, "s", function() require("flash").jump() end, { desc = "Flash" })
            vim.keymap.set({ "n", "x", "o" }, "S", function() require("flash").treesitter() end, { desc = "Flash Treesitter" })
            vim.keymap.set("o", "r", function() require("flash").remote() end, { desc = "Flash Remote" })
          '';
        }

        {
          plugin = comment-nvim;
          type = "lua";
          config = ''
            require("ts_context_commentstring").setup({ enable_autocmd = false })

            require("Comment").setup({
              padding = true,
              sticky = true,

              pre_hook = require("ts_context_commentstring.utils").get_cs,
              opleader = { line = "gc" },
            })

            vim.keymap.set("n", "<C-/>", "<Plug>(comment_toggle_linewise_current)", { desc = "Toggle comment" })
            vim.keymap.set("v", "<C-/>", "<Plug>(comment_toggle_linewise_visual)", { desc = "Toggle comment" })
            vim.keymap.set("i", "<C-/>", "<Esc><Plug>(comment_toggle_linewise_current)A", { desc = "Toggle comment" })
          '';
        }

        {
          plugin = cutlass-nvim;
          type = "lua";
          config = ''
            require("cutlass").setup({
              cut_key = "X",
              exclude = { "ns", "nS" },
            })
          '';
        }

        {
          plugin = nvim-autopairs;
          type = "lua";
          config = ''
            require("nvim-autopairs").setup({
              check_ts = true,
              ts_config = { lua = { "string", "source" }, javascript = { "string", "template_string" } },
              disable_filetype = { "TelescopePrompt", "spectre_panel", "grug-far" },
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

        {
          plugin = tabout-nvim;
          type = "lua";
          config = ''
            require("tabout").setup({
              tabkey = "<Tab>",
              backwards_tabkey = "<S-Tab>",
              act_as_tab = true,
              act_as_shift_tab = false,
              enable_backwards = true,
              completion = true,
              tabouts = {
                { open = "'", close = "'" },
                { open = '"', close = '"' },
                { open = "`", close = "`" },
                { open = "(", close = ")" },
                { open = "[", close = "]" },
                { open = "{", close = "}" },
              },
            })
          '';
        }
      ];

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
        vim.opt.whichwrap:append("<,>,h,l,[,]")

        -- Font size adjustment
        local function change_font_size(delta)
          local guifont = vim.o.guifont
          if guifont == "" then return end
          local size = tonumber(guifont:match(":h(%d+)$")) or 12
          local new_size = math.max(6, size + delta)
          local base = guifont:gsub(":h%d+$", "")
          vim.o.guifont = base .. ":h" .. new_size
        end
      '';
    };
}
