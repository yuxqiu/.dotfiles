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
              rev = "272f99b22574f50e4266791c86b9302682970e23"; # follow:branch main
              hash = "sha256-3muzsPd/1OgGgG+aIpXWUm9R2Lxa1I/geJxmNL8VJAY=";
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
