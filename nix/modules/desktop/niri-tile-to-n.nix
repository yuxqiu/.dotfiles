{
  flake.modules.homeManager.niri =
    { pkgs, ... }:
    let
      niri-tweaks-src = pkgs.fetchFromGitHub {
        owner = "heyoeyo";
        repo = "niri_tweaks";
        rev = "5ad22bbf133122028dcada7d44c96e17def00e13"; # follow:branch main
        hash = "sha256-U/9ygHZhw4S08PzELW/m3QiGZse4SQBO7JdbQZGecwQ=";
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
