{ inputs, ... }:
{
  flake.modules.homeManager.ai =
    { pkgs, ... }:
    let
      browse = pkgs.callPackage (inputs.self + /packages/browse.nix) { };
    in
    {
      home.packages = [ browse pkgs.chromium ];

      programs.agent-skills.sources.browserbase-skills = {
        path = pkgs.fetchFromGitHub {
          owner = "browserbase";
          repo = "skills";
          rev = "b2ae7283497efec71533d292b19b874dd9d0fc4e"; # follow:branch main
          hash = "sha256-Zo6/bY8zlEpf6DiHSlRfXkQTUTUb9GVF5dfTQBXOESA=";
        };
        subdir = "skills";
      };
    };
}