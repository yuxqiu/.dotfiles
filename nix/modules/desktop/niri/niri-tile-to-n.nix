{
  flake.modules.homeManager.niri =
    { pkgs, lib, ... }:
    let
      niri-tweaks-src = pkgs.fetchFromGitHub {
        owner = "heyoeyo";
        repo = "niri_tweaks";
        rev = "dec00a2223abe587bccc23f3b8e5c84de7d33896"; # follow:branch main
        hash = "sha256-wxusxzWTB3L1k38wN+5uzKez3Lk/i5sKJWVqknoxsqE=";
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
      wayland.windowManager.niri.settings._children = lib.mkAfter [
        { spawn-at-startup._args = [ "${niri-tile-to-n}/bin/niri-tile-to-n" ]; }
      ];
    };
}
