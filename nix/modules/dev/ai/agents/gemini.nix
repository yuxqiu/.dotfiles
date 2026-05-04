{
  flake.modules.homeManager.ai = {
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
