{
  flake.modules.homeManager.niri =
    { pkgs, ... }:
    let
      niri-tweaks-src = pkgs.fetchFromGitHub {
        owner = "heyoeyo";
        repo = "niri_tweaks";
        rev = "9ac2bac680cc643513030f56318d949fb285c66e"; # follow:branch main
        hash = "sha256-vr7SvpdwhZKT1h/WWzz2+pozl04HtsU8pluDhHsCMDI=";
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
