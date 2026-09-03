{ inputs, ... }:
{
  flake.modules.homeManager.mdbrowse =
    { config, pkgs, ... }:
    let
      terminal-browser = inputs.terminal-browser.packages.${pkgs.stdenv.system}.default;
      mdbrowseUnwrapped = inputs.mdbrowse.packages.${pkgs.stdenv.system}.default;
      mdbrowse = pkgs.writeShellApplication {
        name = "mdbrowse";
        text = ''
          exec ${mdbrowseUnwrapped}/bin/mdbrowse \
            --zoom 1.2 \
            --bg '${config.lib.stylix.colors.withHashtag.base00}' \
            "$@"
        '';
      };
    in
    {
      home.packages = [
        mdbrowse
        terminal-browser
      ];
    };
}
