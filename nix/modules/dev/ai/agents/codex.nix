{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.codex = {
        enable = true;
        enableMcpIntegration = true;
        settings = {
          analytics.enabled = false;
          web_search = "live";
        };
      };
      my.dev.lsp = with pkgs; [ codex-acp ];
    };
}
