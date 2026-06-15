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
              rev = "3a6fc6392823e31e2362091bd4e3cddf5b77af14"; # follow:branch main
              hash = "sha256-QfZEAw70Kqnm99mvEGwgKsRjzJUqsk6cC8nvku+IRVU=";
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
