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
          rev = "98f2732d55781ac48780f88afafc7bd689beb9f5"; # follow:branch main
          hash = "sha256-3EjRoYyQ7vsGEt7sjjuvc8gfgmJbLFZMGkmJ53e+KIk=";
        };
        subdir = "skills";
      };
    };
}
