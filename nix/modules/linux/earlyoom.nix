{ ... }: {
  config = {
    environment = {
      etc = {
        "default/earlyoom".text = ''
          EARLYOOM_ARGS="-n -r 0 -m 10 --prefer '^(Web Content|Isolated Web Co)$' --avoid '^(greetd|systemd|systemd-logind|dbus-daemon|dbus-broker|niri)$'"

          # More documentation at `man earlyoom` or `earlyoom -h`.
        '';
      };
    };
  };
}
