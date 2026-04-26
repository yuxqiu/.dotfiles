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
            rev = "2c606141936f1eeef17fa3043a72095b4765b9c2"; # follow:branch main
            hash = "sha256-4z/wRdYH7UXRzF8RJU0sw8xbpx0BW/7CBv5sVEC2knY=";
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
