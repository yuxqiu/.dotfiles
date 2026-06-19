{
  flake.modules.homeManager.nvim =
    { pkgs, ... }:
    {
      programs.neovim = {
        enable = true;
        viAlias = true;
        vimAlias = true;

        extraConfig = ''
          let mapleader = ' '
          nnoremap <leader> <Nop>
        '';

        initLua = ''
          _G._lazy_loaded = {}

          _G.lazy_load = function(pack_name, before_fn, after_fn)
            if _G._lazy_loaded[pack_name] then return end
            _G._lazy_loaded[pack_name] = true
            if before_fn then before_fn() end
            vim.cmd("packadd " .. pack_name)
            if after_fn then after_fn() end
          end

          _G._debounce_timers = {}

          _G.debounce = function(key, ms, fn)
            if _G._debounce_timers[key] then
              _G._debounce_timers[key]:stop()
              _G._debounce_timers[key]:close()
            end
            _G._debounce_timers[key] = vim.uv.new_timer()
            _G._debounce_timers[key]:start(ms, 0, function()
              _G._debounce_timers[key]:close()
              _G._debounce_timers[key] = nil
              vim.schedule(fn)
            end)
          end

          _G.open_result_split = function(title, lines)
            local buf = vim.api.nvim_create_buf(false, true)
            vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
            vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
            vim.api.nvim_set_option_value("modifiable", false, { buf = buf })
            vim.api.nvim_set_option_value("filetype", "log", { buf = buf })
            vim.cmd("belowright split")
            vim.api.nvim_win_set_buf(0, buf)
            vim.api.nvim_buf_set_name(buf, title or "Code Lens Result")
          end
        '';

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
          nvim-treesitter-parsers.latex

          {
            plugin = catppuccin-nvim;
            type = "lua";
            config = ''
              vim.cmd.colorscheme("catppuccin-mocha")
            '';
          }

          editorconfig-vim

          {
            plugin = todo-comments-nvim;
            type = "lua";
            config = ''
              require("todo-comments").setup()
            '';
          }

          nvim-web-devicons

          {
            plugin = nvim-hlslens;
            type = "lua";
            config = ''
              require("hlslens").setup({})
            '';
          }

          {
            plugin = nvim-scrollview;
            type = "lua";
            config = ''
              require("scrollview").setup({
                signs_on_startup = { "diagnostics", "search", "marks" },
                scrollview_mousemove = true,
              })
              require("scrollview.contrib.gitsigns").setup()

              vim.keymap.set("n", "<leader>jn", "<cmd>ScrollViewNext<CR>", { desc = "Next scrollview sign" })
              vim.keymap.set("n", "<leader>jp", "<cmd>ScrollViewPrev<CR>", { desc = "Prev scrollview sign" })
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
                rust = { "clippy" },
                sh = { "shellcheck" },
                yaml = { "yamllint" },
              }

              vim.api.nvim_create_autocmd({ "BufWritePost" }, {
                callback = function()
                  debounce("lint:" .. vim.api.nvim_buf_get_name(0), 500, function()
                    lint.try_lint()
                  end)
                end,
              })

              vim.api.nvim_create_autocmd({ "CursorHold" }, {
                callback = function()
                  lint.try_lint()
                end,
              })
            '';
          }
        ];

        extraPackages = with pkgs; [
          ripgrep
          fd
        ];
      };

      home.sessionVariables = {
        EDITOR = "${pkgs.neovim}/bin/nvim";
        VISUAL = "${pkgs.neovim}/bin/nvim";
      };

      stylix.targets.neovim.enable = false;

      xdg.mimeApps = {
        associations.added = {
          "application/json" = [ "nvim.desktop" ];
          "application/x-zerosize" = [ "nvim.desktop" ];
          "text/markdown" = [ "nvim.desktop" ];
          "text/plain" = [ "nvim.desktop" ];
          "text/x-c++src" = [ "nvim.desktop" ];
          "text/x-csrc" = [ "nvim.desktop" ];
          "text/x-python" = [ "nvim.desktop" ];
          "text/x-shellscript" = [ "nvim.desktop" ];
          "text/x-tex" = [ "nvim.desktop" ];
          "text/x-typst" = [ "nvim.desktop" ];
        };
        defaultApplications = {
          "application/json" = [ "nvim.desktop" ];
          "application/x-zerosize" = [ "nvim.desktop" ];
          "text/markdown" = [ "nvim.desktop" ];
          "text/plain" = [ "nvim.desktop" ];
          "text/x-c++src" = [ "nvim.desktop" ];
          "text/x-csrc" = [ "nvim.desktop" ];
          "text/x-python" = [ "nvim.desktop" ];
          "text/x-shellscript" = [ "nvim.desktop" ];
          "text/x-tex" = [ "nvim.desktop" ];
          "text/x-typst" = [ "nvim.desktop" ];
        };
      };
    };
}
