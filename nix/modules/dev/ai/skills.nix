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
              rev = "0877403d1e867fd9d574117e9b34ade404f36d2a"; # follow:branch main
              hash = "sha256-2+2WR5Soqx4g7/T2YiOFj4XMGT5jGjnzOJlQ5ybCRS8=";
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
