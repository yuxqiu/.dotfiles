{
  flake.modules.homeManager.niri =
    { pkgs, lib, ... }:
    let
      niri-tweaks-src = pkgs.fetchFromGitHub {
        owner = "heyoeyo";
        repo = "niri_tweaks";
        rev = "d6ea322006102e36062e2117d34ab53d9c41e92f"; # follow:branch main
        hash = "sha256-1CNpOg2qK0vqVKQLgDUABVKC6l/JbmiNpWtWg1ChY/w=";
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
