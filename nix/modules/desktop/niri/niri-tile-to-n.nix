{
  flake.modules.homeManager.niri =
    { pkgs, lib, ... }:
    let
      niri-tweaks-src = pkgs.fetchFromGitHub {
        owner = "heyoeyo";
        repo = "niri_tweaks";
        rev = "3fd68a1598bd1fac8a7578a09aa9a9b36e19996d"; # follow:branch main
        hash = "sha256-KWxoziukK52nTvPAkxq3lURVZyPXxWioBedmbZlb1us=";
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
      # Workaround: niri's config generator (writeText) doesn't track
      # string-interpolated store paths as runtime dependencies, so this
      # would get GC'd. Remove once upstream niri HM module fixes this.
      home.packages = [ niri-tile-to-n ];

      wayland.windowManager.niri.settings._children = lib.mkAfter [
        { spawn-at-startup._args = [ "${niri-tile-to-n}/bin/niri-tile-to-n" ]; }
      ];
    };
}
