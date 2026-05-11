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
          rev = "v0.12.0-beta.1";
          hash = "sha256-ckbhYPJtFtiL0GpjAJIDi46Oug0fDRZwNj28D4dYZPU=";
        };
        subdir = "skills/hunk-review";
      };
    };
}
