{ inputs, ... }:
{
  flake.modules.homeManager.base =
    { config, pkgs, ... }:
    {
      imports = [ inputs.agent-skills-nix.homeManagerModules.default ];

      # skills credits
      # - create-pr: marcelorodrigo/agent-skills
      programs.agent-skills = {
        enable = true;

        sources.local.path = ./skills;

        sources.karpathy-guidelines = {
          path = pkgs.fetchFromGitHub {
            owner = "forrestchang";
            repo = "andrej-karpathy-skills";
            rev = "c9a44ae835fa2f5765a697216692705761a53f40"; # follow: main
            hash = "sha256-l6qmVV3QI6E3/lrTks1PWt8Tfp43qMN5DG7GdubVTpM=";
          };
          subdir = "skills/karpathy-guidelines";
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
