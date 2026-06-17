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
          rev = "86f5d513dcdc555655f29f6caf418025ff60ea9b"; # follow:branch main
          hash = "sha256-UsHK7WP9fxhkJNxUPnA59t2a3Ygan8eHRHMg+N9hGs0=";
        };
        subdir = "skills";
      };
    };
}
