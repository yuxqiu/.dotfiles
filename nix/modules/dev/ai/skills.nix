{ inputs, ... }:
{
  flake.modules.homeManager.ai =
    { config, pkgs, ... }:
    {
      imports = [ inputs.agent-skills-nix.homeManagerModules.default ];

      # skills credits
      # - create-pr: marcelorodrigo/agent-skills
      programs.agent-skills = {
        enable = true;

        sources = {
          local.path = ./skills;
          addyosmani-agent-skills = {
            path = pkgs.fetchFromGitHub {
              owner = "addyosmani";
              repo = "agent-skills";
              rev = "2e0dfbfb436ef3307bbe8ba172f14996de980784"; # follow:branch main
              hash = "sha256-PGJJN2yEpR2yaHnLOyBCsYdx/Q3FfSvIxr3rNVPBOg8=";
            };
            subdir = "skills";
          };
        };

        skills.enableAll = [
          "local"
          "addyosmani-agent-skills"
        ];

        targets = {
          codex = {
            dest = "${config.home.homeDirectory}/.codex/skills";
            structure = "symlink-tree";
          };
          gemini = {
            dest = "${config.home.homeDirectory}/.gemini/skills";
            structure = "symlink-tree";
          };
          opencode = {
            dest = "${config.home.homeDirectory}/.config/opencode/skills";
            structure = "symlink-tree";
          };
        };
      };
    };
}
