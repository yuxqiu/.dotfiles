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
          rev = "d919e311d6ce8d8b3daa5f33853e67e43a545b9a"; # follow:branch main
          hash = "sha256-/b9JC/ZkeTdqigqAIKwPNJU6hYH1xUY6ZS2SUC4flKQ=";
        };
        subdir = "skills";
      };
    };
}
