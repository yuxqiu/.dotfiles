{
  flake.modules.systemManager.base =
    {
      config,
      lib,
      pkgs,
      utils,
      ...
    }:
    let
      shells = lib.unique (
        lib.concatLists [
          # 1. Reasonable fallback / very common paths seen on real distros
          #    (even if the package isn't actually installed)
          [
            "/bin/sh"
            "/bin/bash"
            "/usr/bin/sh"
            "/usr/bin/bash"

            "/bin/dash"
            "/usr/bin/dash"

            "/bin/rbash"
            "/usr/bin/rbash"

            "/bin/zsh"
            "/usr/bin/zsh"

            "/usr/bin/fish"
            "/bin/fish"

            "/bin/csh"
            "/usr/bin/csh"
            "/bin/tcsh"
            "/usr/bin/tcsh"
          ]

          # 2. Automatically collect real shells from defined users
          #    Skip nonsense values like nologin, false, etc.
          (lib.flatten (
            lib.mapAttrsToList (
              username: user:
              let
                shell = user.shell or null;
              in
              lib.optional (
                shell != null
                && shell != "/usr/sbin/nologin"
                && shell != "/bin/false"
                && shell != "/usr/bin/nologin"
                && shell != pkgs.shadow
              ) (utils.toShellPath shell)
            ) config.users.users
          ))

          # 3. Any shells the user explicitly asked for via the option
          #    (these come last / highest priority)
          (map utils.toShellPath config.environment.shells or [ ])
        ]
      );
    in
    {
      environment.etc = {
        "shells" = {
          text = lib.concatStringsSep "\n" shells;
          mode = "0644";
        };
      };
    };
}
