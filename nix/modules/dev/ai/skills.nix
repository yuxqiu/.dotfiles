{ inputs, ... }:
{
  flake.modules.homeManager.skills =
    { pkgs, ... }:
    {
      imports = [ inputs.agent-skills-nix.homeManagerModules.default ];

      programs.agent-skills = {
        enable = true;

        sources = {
          mattpocock-skills = {
            path = pkgs.fetchFromGitHub {
              owner = "mattpocock";
              repo = "skills";
              rev = "d574778f94cf620fcc8ce741584093bc650a61d3"; # follow:branch main
              hash = "sha256-XqF709Y9GMKINzZITlbCTyatG9AxRZh0qn2vcv1Z8yo=";
            };
            subdir = "skills/engineering";
          };
        };

        skills.enableAll = [
          "mattpocock-skills"
        ];

        targets.agents.enable = true;
      };
    };
}
