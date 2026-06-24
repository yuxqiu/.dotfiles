{ inputs, ... }:
{
  flake.modules.homeManager.nvim =
    {
      pkgs,
      ...
    }:
    {
      imports = [ inputs.nixvim.homeModules.nixvim ];

      programs.nixvim = {
        enable = true;
        viAlias = true;
        vimAlias = true;
        defaultEditor = true;
        wrapRc = true;

        luaLoader.enable = true;
        performance.byteCompileLua.enable = true;

        globals = {
          loaded_ruby_provider = 0;
          loaded_perl_provider = 0;
        };

        extraConfigVim = ''
          let mapleader = ' '
          nnoremap <leader> <Nop>
        '';

        plugins.lz-n.enable = true;

        extraConfigLua = ''
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

          require("hlslens").setup({})

          require("scrollview.contrib.gitsigns").setup()
        '';

        colorschemes.catppuccin = {
          enable = true;
          settings.flavour = "mocha";
        };

        editorconfig.enable = true;

        plugins.treesitter = {
          enable = true;
          grammarPackages = [
            pkgs.vimPlugins.nvim-treesitter-parsers.vim
            pkgs.vimPlugins.nvim-treesitter-parsers.vimdoc
          ];
          settings = {
            highlight.enable = true;
            indent.enable = true;
            folding.enable = true;
          };
        };

        plugins.lint = {
          enable = true;
          luaConfig.post = ''
            vim.api.nvim_create_autocmd({ "BufWritePost" }, {
              callback = function()
                _G.debounce("lint:" .. vim.api.nvim_buf_get_name(0), 500, function()
                  require("lint").try_lint()
                end)
              end,
            })

            vim.api.nvim_create_autocmd({ "CursorHold" }, {
              callback = function()
                require("lint").try_lint()
              end,
            })
          '';
        };

        plugins.todo-comments.enable = true;

        plugins.web-devicons.enable = true;

        plugins.scrollview = {
          enable = true;
          settings = {
            signs_on_startup = [
              "diagnostics"
              "search"
              "marks"
            ];
            mousemove = true;
          };
        };

        extraPlugins = with pkgs.vimPlugins; [
          nvim-hlslens
        ];

        keymaps = [
          {
            key = "<leader>jn";
            action = "<cmd>ScrollViewNext<CR>";
            options.desc = "Next scrollview sign";
          }
          {
            key = "<leader>jp";
            action = "<cmd>ScrollViewPrev<CR>";
            options.desc = "Prev scrollview sign";
          }
        ];

        extraPackages = with pkgs; [
          ripgrep
          fd
        ];
      };

      stylix.targets.nixvim.enable = false;

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
