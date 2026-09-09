{
  flake.modules.homeManager.jj =
    { config, ... }:
    {
      programs.jujutsu = {
        enable = true;
        settings = {
          signing = {
            behavior = "own";
            backend = "ssh";
            key = config.my.user.keys."github-sign";
          };
        };
      };
    };
}
