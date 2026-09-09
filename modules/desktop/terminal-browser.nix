{ inputs, ... }:
{
  flake.modules.homeManager.terminal-browser =
    { pkgs, ... }:
    let
      terminal-browser = inputs.terminal-browser.packages.${pkgs.stdenv.system}.default;
    in
    {
      home.packages = [ terminal-browser ];
    };
}
