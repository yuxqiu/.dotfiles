{
  flake.modules.homeManager.niri =
    { pkgs, ... }:
    let
      niri-tweaks-src = pkgs.fetchFromGitHub {
        owner = "heyoeyo";
        repo = "niri_tweaks";
        rev = "d58dadc1eaf19cbfd0c31d91e5403d5cbb102336"; # follow:branch main
        hash = "sha256-XiVDbPS39EpD2jxIxs5EEPB3NCG32+mTlXAaCfAlJaA=";
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
