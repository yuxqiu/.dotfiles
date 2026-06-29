{
  flake.modules.homeManager.codex = {
    programs.codex = {
      enable = true;
      enableMcpIntegration = true;
      settings = {
        analytics.enabled = false;
        web_search = "live";
      };
    };
  };
}
