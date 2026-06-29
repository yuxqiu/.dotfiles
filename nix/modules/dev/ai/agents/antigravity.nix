{
  flake.modules.homeManager.antigravity = {
    programs.antigravity-cli = {
      enable = true;
      enableMcpIntegration = true;
      settings = {
        privacy.usageStatisticsEnabled = false;
        security.auth.selectedType = "oauth-personal";
      };
    };
  };
}
