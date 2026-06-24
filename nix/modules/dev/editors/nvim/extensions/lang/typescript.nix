{
  flake.modules.homeManager.nvim =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    lib.mkIf (config.my.dev.languages ? typescript) {
      programs.nixvim = {
        plugins.lsp.servers.ts_ls.enable = true;
        plugins.conform-nvim.settings.formatters_by_ft = {
          typescript = [ "prettier" ];
          javascript = [ "prettier" ];
        };
      };
    };
}
