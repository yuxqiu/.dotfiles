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
          rev = "b8e0afab4545afcfae35a6c8b8fca86d7b99893e"; # follow:branch main
          hash = "sha256-ewuxRGOeG+IsvhT0rD4YwE9DK20x8CJB+vGddefiy0w=";
        };
        subdir = "skills";
      };
    };
}
