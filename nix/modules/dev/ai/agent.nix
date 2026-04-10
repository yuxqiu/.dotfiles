{
  flake.modules.homeManager.base = {
    programs.codex = {
      enable = true;
      enableMcpIntegration = true;
      settings = {
        analytics.enabled = false;
        web_search = "live";
      };
    };

    programs.gemini-cli = {
      enable = true;
      enableMcpIntegration = true;
      settings = {
        privacy.usageStatisticsEnabled = false;
        security.auth.selectedType = "oauth-personal";
      };
    };

    programs.opencode = {
      enable = true;
      enableMcpIntegration = true;
      settings = {
        autoupdate = false;
      };
    };
  };
}
