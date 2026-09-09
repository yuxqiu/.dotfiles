{ inputs, ... }:
{
  flake.modules.homeManager.herdr =
    { pkgs, ... }:
    {
      home.packages = [ inputs.herdr.packages.${pkgs.stdenv.system}.default ];

      programs.agent-skills.sources.herdr = {
        path = inputs.herdr;
        subdir = "skills/herdr";
      };
      programs.agent-skills.skills.enableAll = [ "herdr" ];
    };
}
