{
  flake.modules.homeManager.nvim =
    { pkgs, ... }:
    {
      programs.neovim.plugins = with pkgs.vimPlugins; [
        {
          plugin = typst-vim;
          optional = true;
        }

        {
          plugin = vimtex;
          optional = true;
        }
      ];

      programs.neovim.initLua = ''
        vim.api.nvim_create_autocmd("FileType", {
          pattern = "typst",
          callback = function()
            lazy_load("typst.vim", function()
              vim.g.typst_auto_compile = 0
              vim.g.typst_pdf_viewer = "sioyek"
            end, nil)
          end,
        })

        vim.api.nvim_create_autocmd("FileType", {
          pattern = { "tex", "latex", "bib" },
          callback = function()
            lazy_load("vimtex", function()
              vim.g.vimtex_view_method = "sioyek"
              vim.g.vimtex_compiler_method = "tectonic"
              vim.g.vimtex_compiler_tectonic = {
                options = { "--synctex", "--keep-logs", "--keep-intermediates", "-Z", "continue-on-errors" },
              }
              vim.g.tex_flavor = "latex"
              vim.g.vimtex_quickfix_mode = 2
            end, function()
              vim.fn["vimtex#init"]()
            end)
          end,
        })

        vim.api.nvim_create_autocmd("User", {
          pattern = "VimtexEventInitPost",
          callback = function()
            local group = vim.api.nvim_create_augroup("vimtex_auto_compile", { clear = false })
            vim.api.nvim_create_autocmd("BufWritePost", {
              group = group,
              buffer = 0,
              callback = function()
                vim.cmd("VimtexStop")
                vim.cmd("VimtexCompileSS")
              end,
            })
            vim.cmd("VimtexCompileSS")
          end,
        })
      '';
    };
}
