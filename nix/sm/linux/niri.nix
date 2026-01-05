{
  inputs,
  pkgs,
  ...
}:
{
  # It is necessary to install niri system-wide as it is
  # used by dms-greeter to render itself.
  environment.systemPackages = [
    inputs.niri.packages.${pkgs.stdenv.system}.default
  ];

  services.displayManager.waylandSessions = {
    enable = true;

    entries = [
      {
        compositorName = "Niri";
        sessionName = "${inputs.niri.packages.${pkgs.stdenv.system}.default}/bin/niri-session";
      }
    ];
  };
}
