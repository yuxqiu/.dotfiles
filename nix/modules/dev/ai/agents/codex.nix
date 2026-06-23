{
  flake.modules.homeManager.ai = {
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
