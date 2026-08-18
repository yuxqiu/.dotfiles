{
  flake.modules.homeManager.codex =
    { config, ... }:
    {
      programs = {
        codex = {
          enable = true;
          enableMcpIntegration = true;
          settings = {
            analytics.enabled = false;
            web_search = "live";
          };
          # Ingest the shared AGENTS.md content as Codex's global AGENTS.md.
          context = config.my.agents-md.content;
        };

        agent-skills.targets.codex.enable = true;
      };
    };
}
