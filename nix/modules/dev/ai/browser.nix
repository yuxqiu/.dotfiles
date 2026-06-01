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
          rev = "392539ffdaf5c916ba08177735ef043236546b9b"; # follow:branch main
          hash = "sha256-TefqLncd1JlTQrO8AUSgp5H6zV2UnKSLD0VNQEWjz6k=";
        };
        subdir = "skills";
      };
    };
}
