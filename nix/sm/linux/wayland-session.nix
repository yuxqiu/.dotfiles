{ pkgs, ... }:
{
  # Ensure that niri-session can be picked up by display manager
  systemd.tmpfiles.rules = [
    (
      let
        niriDesktop = pkgs.writeText "niri.desktop" ''
          [Desktop Entry]
          Name=Niri
          Comment=A scrollable-tiling Wayland compositor
          Exec=niri-session
          Type=Application
          DesktopNames=niri
        '';
      in
      "L+ /usr/share/wayland-sessions/niri.desktop - - - - ${niriDesktop}"
    )
  ];
}
