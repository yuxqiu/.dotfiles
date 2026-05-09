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
          rev = "v0.10.0";
          hash = "sha256-S2EuZW5vzyk3FGhUQbyanE3hdlnb9F6GQMtu2k8pjrM=";
        };
        subdir = "skills/hunk-review";
      };
    };
}
