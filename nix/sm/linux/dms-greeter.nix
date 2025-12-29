{ pkgs, ... }:

let
  # A workaround to
  #
  # 1. let dms-greeter to find niri to launch quickshell
  # 2. let quickshell to launch niri-session
  compositorPath = "/run/system-manager/sw/bin";

  greeterScript = pkgs.writeShellScript "dms-greeter-with-profile" ''
    export PATH=${compositorPath}:$PATH

    # Now launch the actual greeter, passing the desired command to start after login
    exec /usr/bin/dms-greeter --command niri
  '';
in
{
  config.environment.etc = {
    "greetd/config.toml" = {
      text = ''
        [terminal]
        # The VT to run the greeter on. Can be "next", "current" or a number
        # designating the VT.
        vt = 1

        # The default session, also known as the greeter.
        [default_session]

        command = "${greeterScript}"

        # The user to run the command as. The privileges this user must have depends
        # on the greeter. A graphical greeter may for example require the user to be
        # in the `video` group.
        user = "greeter"
      '';
      mode = "0644";
    };
  };
}
