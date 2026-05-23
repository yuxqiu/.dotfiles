{ inputs, ... }:
{
  flake.modules.homeManager.ai =
    { pkgs, ... }:
    {
      home.packages = [ inputs.omp.packages.${pkgs.stdenv.system}.default ];

      # ── omp config paths ──
      # Config file: ~/.omp/agent/config.yml  (theme, model roles, extensions, etc.)
      # Models file:  ~/.omp/agent/models.yml  (providers, model overrides, discovery)
      # MCP servers:  ~/.omp/agent/mcp.json    (or .omp/mcp.json per-project)
      # Extensions:   ~/.omp/agent/extensions/  (discovered automatically)
      # Skills:       ~/.omp/agent/skills/       (skill:// internal URLs)
      # Custom tools: ~/.omp/agent/tools/         (discovered automatically)
      # Slash commands: ~/.omp/agent/commands/    (or .omp/commands/ per-project)
      # Custom agents: ~/.omp/agent/agents/       (or .omp/agents/ per-project)
      # Themes:       ~/.omp/agent/themes/        (custom theme JSON files)
      # Rules:        .omp/rules/                 (per-project, regex-triggered TTSR rules)

      home.file.".omp/agent/extensions/undo.ts".source = ./extensions/undo.ts;
    };
}
