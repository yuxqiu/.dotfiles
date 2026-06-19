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
          rev = "8102b959d0e7fb5b11fd91a381ce64f2b1d5fd24"; # follow:branch main
          hash = "sha256-IlwGnX9+ueTqJANRWacXuuo55AikGR6LS02ZpfhOywA=";
        };
        subdir = "skills";
      };
    };
}
