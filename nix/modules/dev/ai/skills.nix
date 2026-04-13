{ inputs, ... }:
{
  flake.modules.homeManager.base =
    { config, ... }:
    {
      imports = [ inputs.agent-skills-nix.homeManagerModules.default ];

      # skills credits
      # - create-pr: marcelorodrigo/agent-skills
      programs.agent-skills = {
        enable = true;

        sources.local.path = ./skills;

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
