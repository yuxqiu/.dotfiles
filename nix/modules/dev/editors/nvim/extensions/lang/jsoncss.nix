{
  flake.modules.homeManager.nvim =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    lib.mkIf (config.my.dev.languages ? jsoncss) {
      programs.nixvim = {
        plugins.lsp.servers = {
          jsonls.enable = true;
          cssls.enable = true;
        };
        plugins.conform-nvim.settings.formatters_by_ft = {
          json = [ "prettier" ];
          css = [ "prettier" ];
          scss = [ "prettier" ];
        };
        plugins.treesitter.grammarPackages = with pkgs.vimPlugins.nvim-treesitter-parsers; [
          json
          scss
        ];
      };
    };
}
