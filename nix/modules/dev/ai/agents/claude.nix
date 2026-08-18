{
  flake.modules.homeManager.claude =
    { config, ... }:
    {
      programs = {
        claude-code = {
          enable = true;
          enableMcpIntegration = true;
          settings = {
            includeCoAuthoredBy = false;
            permissions.defaultMode = "acceptEdits";
          };
          # Ingest the shared AGENTS.md content as Claude Code's global CLAUDE.md.
          context = config.my.agents-md.content;
        };

        agent-skills.targets.claude.enable = true;
      };
    };
}
