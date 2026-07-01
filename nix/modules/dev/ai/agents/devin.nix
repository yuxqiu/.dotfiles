{
  flake.modules.homeManager.devin =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.devin-cli ];

      my.agents-md.destinations.devin = ".config/devin/AGENTS.md";
    };
}
