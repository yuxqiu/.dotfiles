{
  flake.modules.homeManager.linux-base =
    { config, ... }:
    {
      # allow systemd to discover user service files installed by nix
      # - https://unix.stackexchange.com/a/696035
      systemd.user.settings.Manager = {
        ManagerEnvironment = {
          XDG_DATA_DIRS = "${config.home.profileDirectory}/share:/nix/var/nix/profiles/default/share";
        };
      };
    };
}
