{
  flake.modules.homeManager.base = {
    programs.gemini-cli = {
      enable = true;
      enableMcpIntegration = true;
      settings = {
        privacy.usageStatisticsEnabled = false;
        security.auth.selectedType = "oauth-personal";
      };
    };
  };
}
