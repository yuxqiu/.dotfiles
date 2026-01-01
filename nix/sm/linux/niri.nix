{ username, ... }:
{
  # A workaround to symlink niri and niri-session to system's path
  # so that they can be picked up by dms-greeter.
  #
  # It will be better to install compositor system-wide via system-manager
  # so that the compositor path can be pointed to fixed location independent
  # of the username. However, system-manager does not support fetching and
  # building from niri's flake directly.
  systemd.tmpfiles.rules = [
    "L+ /run/system-manager/sw/bin/niri - - - - /home/${username}/.nix-profile/bin/niri"
    "L+ /run/system-manager/sw/bin/niri-session - - - - /home/${username}/.nix-profile/bin/niri-session"
  ];

  services.displayManager.waylandSessions = {
    enable = true;

    entries = [
      {
        compositorName = "Niri";
        sessionName = "niri-session";
      }
    ];
  };
}
