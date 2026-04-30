{
  flake.modules.homeManager.linux-desktop =
    { pkgs, ... }:
    let
      niri-tweaks-src = pkgs.fetchFromGitHub {
        owner = "heyoeyo";
        repo = "niri_tweaks";
        rev = "b9a8eca759f0788959cdcfa3ed2f49e7ce077e8b"; # follow:branch main
        hash = "sha256-Tqg1lAcltrQAflap4Q0RMyYEQfO6TbSAuuOT93yzW7I=";
      };

      niri-tile-to-n = pkgs.writeShellApplication {
        name = "niri-tile-to-n";
        runtimeInputs = [ pkgs.python3 ];
        text = ''
          exec python3 ${niri-tweaks-src}/niri_tile_to_n.py -n 3 -delay 5000
        '';
      };
    in
    {
      wayland.windowManager.niri.settings.spawn-at-startup = [
        [ "${niri-tile-to-n}/bin/niri-tile-to-n" ]
      ];
    };
}
