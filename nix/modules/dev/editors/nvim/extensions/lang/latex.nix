{
  flake.modules.homeManager.nvim =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    lib.mkIf (config.my.dev.languages ? latex) {
      programs.nixvim = {
        extraPlugins = with pkgs.vimPlugins; [ vimtex ];

        plugins.lz-n.plugins = [
          {
            __unkeyed-1 = "vimtex";
            ft = [
              "tex"
              "latex"
              "bib"
            ];
            before.__raw = ''
              function()
                vim.g.vimtex_view_method = "sioyek"
                vim.g.vimtex_compiler_method = "tectonic"
                vim.g.vimtex_compiler_tectonic = {
                  options = { "--untrusted", "--synctex", "--keep-logs", "--keep-intermediates", "-Z", "continue-on-errors" },
                }
                vim.g.tex_flavor = "latex"
                vim.g.vimtex_quickfix_mode = 2
              end
            '';
            after.__raw = ''
              function()
                vim.fn["vimtex#init"]()
              end
            '';
          }
        ];

        autoCmd = [
          {
            event = [ "FileType" ];
            pattern = [
              "tex"
              "latex"
            ];
            callback.__raw = ''
              function()
                vim.opt_local.wrap = true
                vim.opt_local.linebreak = true
              end
            '';
          }
          {
            event = [ "User" ];
            pattern = [ "VimtexEventInitPost" ];
            callback.__raw = ''
              function()
                vim.api.nvim_create_autocmd("BufWritePost", {
                  buffer = 0,
                  callback = function()
                    debounce("vimtex_compile", 500, function()
                      vim.cmd("VimtexStop")
                      vim.cmd("VimtexCompileSS")
                    end)
                  end,
                })
              end
            '';
          }
        ];

        plugins.lsp.servers.texlab = {
          enable = true;
          settings = {
            texlab = {
              build = {
                onSave = false;
                forwardSearchAfter = false;
                executable = "tectonic";
                args = [
                  "-X"
                  "compile"
                  "%f"
                  "--untrusted"
                  "--synctex"
                  "--keep-logs"
                  "--keep-intermediates"
                ];
              };
              diagnostics = {
                ignoredPatterns = [ "Unused" ];
                delay = 0.4;
              };
            };
          };
        };

        plugins.conform-nvim.settings.formatters_by_ft = {
          tex = [ "latexindent" ];
          bib = [ "latexindent" ];
        };
        plugins.treesitter.grammarPackages = with pkgs.vimPlugins.nvim-treesitter-parsers; [ latex ];
      };
    };
}
