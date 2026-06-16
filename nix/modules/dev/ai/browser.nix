{ inputs, ... }:
{
  flake.modules.homeManager.ai =
    { pkgs, ... }:
    let
      browse = pkgs.callPackage (inputs.self + /packages/browse.nix) { };
    in
    {
      home.packages = [
        browse
        pkgs.chromium
      ];

      programs.agent-skills.sources.browserbase-skills = {
        path = pkgs.fetchFromGitHub {
          owner = "browserbase";
          repo = "skills";
          rev = "d61ba596636bdb28ba019102993cd8ce9607a3db"; # follow:branch main
          hash = "sha256-Abo3z6PKxGY/cY2w7VroVuHkcGtq7vSa0evihhuvFIE=";
        };
        subdir = "skills";
      };
    };
}
