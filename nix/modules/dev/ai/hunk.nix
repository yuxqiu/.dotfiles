{ inputs, ... }:
{
  flake.modules.homeManager.ai =
    { pkgs, ... }:
    let
      hunk = pkgs.callPackage (inputs.self + /packages/hunk.nix) { };
    in
    {
      home.packages = [ hunk ];

      programs.agent-skills.sources.hunk-review = {
        path = pkgs.fetchFromGitHub {
          owner = "modem-dev";
          repo = "hunk";
          rev = "b4429c1ce9cd3abb387e39c418151188aa2254df"; # follow:branch main
          hash = "sha256-b6dloQly4mM7VpdLP1bXmr2FManXuEoPH5u61Y1RgCU=";
        };
        subdir = "skills/hunk-review";
      };
    };
}
