{ inputs, ... }:
{
  flake.modules.homeManager.browser =
    { pkgs, ... }:
    let
      browse = pkgs.callPackage (inputs.self + /packages/browse.nix) { };
    in
    {
      home.packages = [
        browse
        pkgs.chromium
      ];

      programs.agent-skills = {
        sources.browse = {
          path = browse.passthru.src;
          subdir = "packages/cli/skills";
        };

        skills.enableAll = [
          "browse"
        ];
      };
    };
}
