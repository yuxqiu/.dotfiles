{ inputs, ... }:
{
  flake.modules.homeManager.ai =
    { pkgs, ... }:
    let
      stagereview = pkgs.callPackage (inputs.self + /packages/stage-cli.nix) { };
    in
    {
      home.packages = [ stagereview ];

      programs.agent-skills.sources.stage-chapters = {
        path = pkgs.fetchFromGitHub {
          owner = "ReviewStage";
          repo = "stage-cli";
          rev = "0ed89555e1d3be9c95731208493551de7f622d4b"; # follow:branch main
          hash = "sha256-xE/2gPo0i1eoDxCTYbWc3B737BcIc/YwiQUwWI0ftL0=";
        };
        subdir = "skills/stage-chapters";
      };
    };
}
