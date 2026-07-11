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
              rev = "391a2701dd948f94f56a39f7533f8eea9a859c87"; # follow:branch main
              hash = "sha256-gFPkjrujFAoNXYa0ariPKTj/xBoiCTLUo3X20qrTzRE=";
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
