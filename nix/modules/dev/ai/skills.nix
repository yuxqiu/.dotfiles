{ inputs, ... }:
{
  flake.modules.homeManager.ai =
    { config, pkgs, ... }:
    {
      imports = [ inputs.agent-skills-nix.homeManagerModules.default ];

        programs.agent-skills = {
          enable = true;

          sources = {
            mattpocock-skills = {
              path = pkgs.fetchFromGitHub {
                owner = "mattpocock";
                repo = "skills";
                rev = "694fa30311e02c2639942308513555e61ee84a6f"; # follow:branch main
                hash = "sha256-NGRKdnHSBKoR48zGotmJ3zGXnQ58ogudv8T4Va/2DSY=";
              };
              subdir = "skills";
            };
          };

          skills.enableAll = [
            "mattpocock-skills"
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
