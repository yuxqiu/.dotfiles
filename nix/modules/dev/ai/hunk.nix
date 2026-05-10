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
          rev = "v0.11.1";
          hash = "sha256-gyNK9WTXmHjWaJulQ4V2k3L6PpctruDLSTcJin5Lxqo=";
        };
        subdir = "skills/hunk-review";
      };
    };
}
