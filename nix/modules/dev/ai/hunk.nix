{ ... }:
{
  flake.modules.homeManager.hunk = { pkgs, ... }: {
    home.packages = with pkgs; [ hunk ];

    programs.agent-skills.sources.hunk-review = {
      path = pkgs.hunk;
      subdir = "share/hunk/skills";
    };
    programs.agent-skills.skills.enableAll = [ "hunk-review" ];
  };
}
