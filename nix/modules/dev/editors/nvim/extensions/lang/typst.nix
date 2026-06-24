{
  flake.modules.homeManager.nvim =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    lib.mkIf (config.my.dev.languages ? typst) {
      programs.nixvim = {
        extraPlugins = with pkgs.vimPlugins; [ typst-vim ];

        plugins.lz-n.plugins = [
          {
            __unkeyed-1 = "typst.vim";
            ft = "typst";
            before.__raw = ''
              function()
                vim.g.typst_auto_compile = 0
                vim.g.typst_pdf_viewer = "sioyek"
              end
            '';
          }
        ];

        extraConfigLua = ''
          vim.api.nvim_create_autocmd("FileType", {
            pattern = "typst",
            callback = function()
              vim.opt_local.wrap = true
              vim.opt_local.linebreak = true
            end,
          })
        '';

        plugins.lsp.servers.tinymist = {
          enable = true;
          settings = {
            exportPdf = "onSave";
            formatterMode = "typstyle";
          };
        };

        plugins.treesitter.grammarPackages = with pkgs.vimPlugins.nvim-treesitter-parsers; [ typst ];
      };
    };
}
