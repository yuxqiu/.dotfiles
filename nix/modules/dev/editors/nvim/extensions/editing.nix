{
  flake.modules.homeManager.nvim =
    { pkgs, lib, ... }:
    {
      programs.nixvim = {
        extraPlugins = with pkgs.vimPlugins; [
          vim-unimpaired
        ];

        plugins.flash = {
          enable = true;
          settings.modes.char = {
            enabled = true;
            autohide = true;
            multi_line = false;
          };
        };

        plugins.comment = {
          enable = true;
          settings = {
            padding = true;
            sticky = true;
            pre_hook.__raw = "require('ts_context_commentstring.utils').get_cs";
            opleader.line = "gc";
          };
        };

        plugins.cutlass-nvim = {
          enable = true;
          settings = {
            cut_key = "X";
            exclude = [
              "ns"
              "nS"
            ];
          };
        };

        plugins.nvim-autopairs = {
          enable = true;
          settings = {
            check_ts = true;
            ts_config = {
              lua = [
                "string"
                "source"
              ];
              javascript = [
                "string"
                "template_string"
              ];
            };
            disable_filetype = [
              "TelescopePrompt"
              "spectre_panel"
              "grug-far"
            ];
            fast_wrap = {
              map = "<M-e>";
              chars = [
                "{"
                "["
                "("
                "\""
                "'"
              ];
              pattern.__raw = ''string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s", "")'';
              end_key = "$";
              keys = "qwertyuiopzxcvbnmasdfghjkl";
              check_comma = true;
              highlight = "Search";
              highlight_grey = "Comment";
            };
          };
        };

        plugins.neotab = {
          enable = true;
          settings = {
            tabkey = "<Tab>";
            reverse_key = "<S-Tab>";
            act_as_tab = true;
            behavior = "nested";
            pairs = [
              {
                open = "(";
                close = ")";
              }
              {
                open = "[";
                close = "]";
              }
              {
                open = "{";
                close = "}";
              }
              {
                open = "'";
                close = "'";
              }
              {
                open = "\"";
                close = "\"";
              }
              {
                open = "`";
                close = "`";
              }
            ];
          };
        };

        plugins.ts-context-commentstring = {
          enable = true;
          settings.enable_autocmd = false;
        };

        extraConfigLua = lib.mkAfter ''
          vim.keymap.set({ "n", "x", "o" }, "s", function() require("flash").jump() end, { desc = "Flash" })
          vim.keymap.set({ "n", "x", "o" }, "S", function() require("flash").treesitter() end, { desc = "Flash Treesitter" })
          vim.keymap.set("o", "r", function() require("flash").remote() end, { desc = "Flash Remote" })

          vim.keymap.set("n", "<C-/>", "<Plug>(comment_toggle_linewise_current)", { desc = "Toggle comment" })
          vim.keymap.set("v", "<C-/>", "<Plug>(comment_toggle_linewise_visual)", { desc = "Toggle comment" })
          vim.keymap.set("i", "<C-/>", "<Esc><Plug>(comment_toggle_linewise_current)A", { desc = "Toggle comment" })

          local cmp_autopairs = require("nvim-autopairs.completion.cmp")
          local cmp = require("cmp")
          cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

          vim.opt.diffopt:append("algorithm:histogram")
          vim.opt.whichwrap:append("<,>,h,l,[,]")

          local function change_font_size(delta)
            local guifont = vim.o.guifont
            if guifont == "" then return end
            local size = tonumber(guifont:match(":h(%d+)$")) or 12
            local new_size = math.max(6, size + delta)
            local base = guifont:gsub(":h%d+$", "")
            vim.o.guifont = base .. ":h" .. new_size
          end

          vim.api.nvim_create_autocmd("CursorHold", {
            callback = function()
              collectgarbage("step", 256)
            end,
          })
        '';

        opts = {
          encoding = "utf-8";
          hidden = true;
          number = true;
          relativenumber = true;
          showmatch = true;
          shiftwidth = 4;
          tabstop = 4;
          expandtab = true;
          smarttab = true;
          formatoptions = "croqln";
          backup = false;
          writebackup = false;
          wrap = false;
          ignorecase = true;
          smartcase = true;
          hlsearch = true;
          mouse = "a";
          wildmode = [
            "longest"
            "list"
          ];
          wildmenu = true;
          foldmethod = "expr";
          foldexpr = "v:lua.vim.treesitter.foldexpr()";
          foldcolumn = "1";
          foldnestmax = 10;
          foldenable = false;
          foldlevel = 99;
          autoindent = true;
          cursorline = true;
          signcolumn = "yes";
          splitbelow = true;
          splitright = true;
          updatetime = 250;
          timeoutlen = 300;
          scrolloff = 8;
          sidescrolloff = 8;
          termguicolors = true;
          clipboard = "unnamedplus";
          showtabline = 2;
          laststatus = 3;
          pumheight = 10;
          inccommand = "split";
        };
      };
    };
}
