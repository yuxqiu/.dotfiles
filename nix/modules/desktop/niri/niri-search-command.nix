{
  flake.modules.homeManager.niri =
    { pkgs, ... }:
    let
      niri-tweaks-src = pkgs.fetchFromGitHub {
        owner = "heyoeyo";
        repo = "niri_tweaks";
        rev = "74acb9d36bde9d777c5b2ba87d8302f00bfd8d42"; # follow:branch main
        hash = "sha256-Ojtvbdb0P+kfEcsfe17eXAcDGnV2eZ63+rQGAJcowyM=";
      };

      niri-search-command = pkgs.writeShellApplication {
        name = "niri-search-command";
        runtimeInputs = [
          pkgs.python3
          pkgs.fuzzel
          pkgs.libnotify
        ];
        text = ''
          exec python3 ${niri-tweaks-src}/niri_search_command.py
        '';
      };
    in
    {
      # fuzzel is the picker used by niri_search_command; enabling it here lets
      # stylix auto-apply the catppuccin-mocha theme (colors/font/icon-theme).
      programs.fuzzel.enable = true;

      home.packages = [ niri-search-command ];

      wayland.windowManager.niri.settings.binds."Mod+Slash".spawn = [ "niri-search-command" ];
    };
}
