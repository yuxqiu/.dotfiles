{
  # crucial to enable sm-managed user login shell
  flake.modules.systemManager.base =
    {
      lib,
      ...
    }:

    {
      options.environment.shells = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [ ];
        description = ''
          List of shell packages whose executable paths should be added to /etc/shells.
          The paths are automatically derived using utils.toShellPath.
        '';
      };
    };
}
