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
          hash = "sha256-S2EuZW5vzyk3FGhUQbyanE3hdlnb9F6GQMtu2k8pjrM=";
        };
        subdir = "skills/hunk-review";
      };
    };
}