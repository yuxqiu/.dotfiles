{
  flake.modules.homeManager.base = {
    programs.tirith = {
      enable = true;
      policy = {
        fail_mode = "open";
        allow_bypass = true;
      };
      enableZshIntegration = true;
    };

    home.sessionVariables = {
      TIRITH_LOG = 0;
    };
  };
}
