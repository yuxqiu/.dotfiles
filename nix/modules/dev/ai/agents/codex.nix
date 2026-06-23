{
  flake.modules.homeManager.ai =
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

      my.dev.languages.codex.toolchain = [ pkgs.codex-acp ];
    };
}
