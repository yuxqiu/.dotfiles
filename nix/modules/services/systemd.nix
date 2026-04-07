{
  flake.modules.homeManager.linux-base =
    {
      config,
      lib,
      ...
    }:
    {
      # A workaround to allow systemd to discover user service files
      # installed by home-manager. Ideally, home-manager modules
      # should properly use `systemd.packages` to specify which
      # systemd services files should be copied into $XDG_DATA_HOME.
      #
      # - https://unix.stackexchange.com/a/696035
      systemd.user.settings.Manager = lib.mkIf config.my.system.isSystemManager {
        ManagerEnvironment = {
          XDG_DATA_DIRS = "${config.home.profileDirectory}/share:/nix/var/nix/profiles/default/share";
        };
      };
    };
}
