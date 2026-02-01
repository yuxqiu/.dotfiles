{
  inputs,
  ...
}:
{
  flake.modules.systemManager.gui =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      dms = inputs.dms.packages.${pkgs.stdenv.system};

      # greetd uses PATH to lookup niri and niri-session
      #
      # - Sidenote: dms-greeter -> quickshell (via niri) ->
      #   niri-session -> niri + niri.service (user)
      waylandSessionPackages = map (e: e.package) config.services.displayManager.waylandSessions.entries;
      greeterPath = lib.makeBinPath (
        [
          dms.quickshell
        ]
        ++ waylandSessionPackages
      );

      # Copied and modified from `distro/nix/greeter.nix`
      greeterScript = pkgs.writeShellScriptBin "dms-greeter" ''
        export PATH=$PATH:${greeterPath}

        ${dms.dms-shell}/share/quickshell/dms/Modules/Greetd/assets/dms-greeter \
        --command niri -p ${dms.dms-shell}/share/quickshell/dms
      '';
    in
    {
      environment.etc = {
        "greetd/config.toml" = {
          text = ''
            [terminal]
            # The VT to run the greeter on. Can be "next", "current" or a number
            # designating the VT.
            vt = 1

            # The default session, also known as the greeter.
            [default_session]

            command = "${greeterScript}/bin/dms-greeter"

            # The user to run the command as. The privileges this user must have depends
            # on the greeter. A graphical greeter may for example require the user to be
            # in the `video` group.
            user = "greeter"
          '';
          mode = "0644";
        };
      };
    };
}
