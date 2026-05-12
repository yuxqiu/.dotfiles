{ inputs, ... }:
{
  flake.modules.homeManager.ai = {
    imports = [ inputs.hunk.homeManagerModules.default ];

    programs.hunk = {
      enable = true;
    };

    programs.agent-skills.sources.hunk-review = {
      path = inputs.hunk;
      subdir = "skills/hunk-review";
    };
  };
}
