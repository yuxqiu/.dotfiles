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
              rev = "f17c6e88c904dc747381c374312c2d58e10647ae"; # follow:branch main
              hash = "sha256-ULWkCoc+qSeJO+qlGL9ZvlJKgu/zER8c82vc/8HrTro=";
            };
            subdir = "skills";
          };
        };

        skills = {
          enableAll = true;
        };

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
