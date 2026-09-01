{
  flake.modules.homeManager.git =
    { config, ... }:
    {
      programs.git.settings.user = {
        name = config.my.user.name;
        email = config.my.user.email;
      };
    };
}
