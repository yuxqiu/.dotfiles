{
  flake.modules.homeManager.nvim =
    { pkgs, config, lib, ... }:
    lib.mkIf (config.my.dev.languages ? typst) {
      programs.neovim.plugins = with pkgs.vimPlugins; [
        {
          plugin = typst-vim;
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
          pattern = "typst",
          callback = function()
            vim.opt_local.wrap = true
            vim.opt_local.linebreak = true
          end,
        })
      '';
    };
}
