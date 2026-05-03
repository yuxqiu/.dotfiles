{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.neovim = {
        enable = true;
        viAlias = true;
        vimAlias = true;

        extraConfig = "let mapleader = ' '";

        initLua = ''
          _G._lazy_loaded = {}

          _G.lazy_load = function(pack_name, before_fn, after_fn)
            if _G._lazy_loaded[pack_name] then return end
            _G._lazy_loaded[pack_name] = true
            if before_fn then before_fn() end
            vim.cmd("packadd " .. pack_name)
            if after_fn then after_fn() end
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
            plugin = fastaction-nvim;
            type = "lua";
            config = ''
              require("fastaction").setup({
                popup = {
                  border = "rounded",
                },
              })

              vim.keymap.set("n", "<C-.>", require("fastaction").code_action, { desc = "Code Action" })
              vim.keymap.set("x", "<leader>ca", require("fastaction").code_action, { desc = "Code Action" })
              vim.keymap.set("n", "<leader>ca", require("fastaction").code_action, { desc = "Code Action" })
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
                python = { "ruff" },
                rust = { "clippy" },
                sh = { "shellcheck" },
                yaml = { "yamllint" },
              }

              vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
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
