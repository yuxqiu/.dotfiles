{
  flake.modules.homeManager.devin =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.devin-cli ];

      programs.agent-skills.targets.windsurf.enable = true;

      my.agents-md.destinations.devin = ".config/devin/AGENTS.md";
    };
}
