{ inputs, ... }:
{
  flake.modules.homeManager.skills =
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
              rev = "5d78bd0903420f97c791f834201e550c765699f8"; # follow:branch main
              hash = "sha256-efsb/AXAmEvcjoknbExBeEHFB28o2c2Nk8muWwNNQFQ=";
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
