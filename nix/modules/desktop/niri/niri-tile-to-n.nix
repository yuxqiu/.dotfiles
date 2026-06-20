{
  flake.modules.homeManager.niri =
    { pkgs, ... }:
    let
      niri-tweaks-src = pkgs.fetchFromGitHub {
        owner = "heyoeyo";
        repo = "niri_tweaks";
        rev = "4b9ac846b9be3b8d283623fa27baa12a46f3f0dc"; # follow:branch main
        hash = "sha256-A/weC44RDIupanPdMqniSuk0yBahGovV5hneporsTNg=";
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
