{
  inputs,
  pkgs,
  ...
}:
{
  services.displayManager.waylandSessions = {
    enable = true;

    entries = [
      {
        compositorName = "Niri";
        sessionName = "niri-session";
        package = inputs.niri.packages.${pkgs.stdenv.system}.default;
      }
    ];
  };
}
