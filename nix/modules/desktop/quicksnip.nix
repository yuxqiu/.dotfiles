{ inputs, ... }:
{
  flake.modules.homeManager.linux-desktop =
    {
      pkgs,
      ...
    }:
    {
      home.packages =
        let
          settingsJson = builtins.toJSON {
            Search = {
              engine = "google";
              open_in = "newtab";
            };
            Selection = {
              style = "rectangle";
            };
            Translation = {
              target_lang = "zh-CN";
              open_in = "newtab";
            };
            AI = {
              provider = "chatgpt";
              open_in = "newtab";
            };
            Lens = {
              open_in = "newtab";
            };
            Smart = {
              ai_threshold = 15;
              open_in = "newtab";
            };
            Browser = {
              class = "zen";
            };
          };
          settingsFile = pkgs.writeText "quicksnip-settings.json" settingsJson;
          configDir = pkgs.runCommand "quicksnip-xdg-config" { } ''
            mkdir -p "$out/quickshell/QuickSnip"
            cp ${settingsFile} "$out/quickshell/QuickSnip/settings.json"
          '';
          quicksnipWrapped = pkgs.symlinkJoin {
            name = "quicksnip-wrapped";
            paths = [ inputs.quicksnip.packages.${pkgs.stdenv.system}.default ];
            buildInputs = [ pkgs.makeWrapper ];
            postBuild = ''
              for bin in "$out/bin/"*; do
                wrapProgram "$bin" --set XDG_CONFIG_HOME "${configDir}"
              done
            '';
          };
        in
        [ quicksnipWrapped ];

      wayland.windowManager.niri.settings.binds."Mod+E" = {
        _props.hotkey-overlay-title = "QuickSnip";
        spawn = "quicksnip";
      };
    };
}
