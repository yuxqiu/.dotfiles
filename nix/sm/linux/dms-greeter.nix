{
  inputs,
  pkgs,
  lib,
  ...
}:
let
  dms = inputs.dms.packages.${pkgs.stdenv.system};
  # Copied and modified from `distro/nix/greeter.nix`
  greeterScript = pkgs.writeShellScriptBin "dms-greeter" ''
    export PATH=$PATH:${
      lib.makeBinPath [
        dms.quickshell
      ]
    }
    ${lib.escapeShellArgs [
      "sh"
      "${dms.dms-shell}/share/quickshell/dms/Modules/Greetd/assets/dms-greeter"
      "--command"
      "niri"
      "-p"
      "${dms.dms-shell}/share/quickshell/dms"
    ]}
  '';
in
{
  # greetd uses PATH to lookup niri and niri-session
  #
  # The PATH does not include the hm one as the user is not
  # login yet. But, it includes the sm one. Since we install
  # niri in sm as well, dms-greeter will find niri and qs will
  # find niri-session.
  # - Sidenote: dms-greeter -> quickshell (via niri) ->
  #   niri-session -> niri + niri.service (user)
  config.environment.etc = {
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
}
