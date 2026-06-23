{
  flake.modules.homeManager.nvim =
    { pkgs, config, lib, ... }:
    lib.mkIf (config.my.dev.languages ? latex) {
      programs.neovim.plugins = with pkgs.vimPlugins; [
        {
          plugin = vimtex;
          optional = true;
        }
      ];

      programs.neovim.initLua = ''
        vim.api.nvim_create_autocmd("FileType", {
          pattern = { "tex", "latex", "bib" },
          callback = function()
            lazy_load("vimtex", function()
              vim.g.vimtex_view_method = "sioyek"
              vim.g.vimtex_compiler_method = "tectonic"
              vim.g.vimtex_compiler_tectonic = {
                options = { "--untrusted", "--synctex", "--keep-logs", "--keep-intermediates", "-Z", "continue-on-errors" },
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
            vim.api.nvim_create_autocmd("BufWritePost", {
              buffer = 0,
              callback = function()
                debounce("vimtex_compile", 500, function()
                  vim.cmd("VimtexStop")
                  vim.cmd("VimtexCompileSS")
                end)
              end,
            })
          end,
        })

        vim.api.nvim_create_autocmd("FileType", {
          pattern = { "tex", "latex" },
          callback = function()
            vim.opt_local.wrap = true
            vim.opt_local.linebreak = true
          end,
        })
      '';
    };
}
