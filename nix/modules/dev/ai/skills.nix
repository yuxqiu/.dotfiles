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
              rev = "2454c95dc305c158b21a0cdafeb728879dd0359a"; # follow:branch main
              hash = "sha256-nuHQ+SG5UerKs334Yk5nsxHOncGXQKF1yVdnwwVpLZ8=";
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
