{
  flake.modules.homeManager.nvim =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    lib.mkIf (config.my.dev.languages ? markdown) {
      programs.nixvim.extraConfigLua = ''
        vim.api.nvim_create_autocmd("FileType", {
          pattern = "markdown",
          callback = function()
            vim.opt_local.wrap = true
            vim.opt_local.linebreak = true
          end,
        })
      '';

      programs.nixvim.plugins.lsp.servers.markdown_oxide.enable = true;
      programs.nixvim.plugins.conform-nvim.settings.formatters_by_ft.markdown = [ "prettier" ];
      programs.nixvim.plugins.treesitter.grammarPackages = with pkgs.vimPlugins.nvim-treesitter-parsers; [
        markdown
        markdown_inline
      ];
    };
}
