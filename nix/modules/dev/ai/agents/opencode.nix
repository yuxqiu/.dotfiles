{
  flake.modules.homeManager.ai =
    { pkgs, config, ... }:
    let
      # enable opencode websearch and lsp support
      # https://opencode.ai/docs/tools
      wrappedOpencode = pkgs.symlinkJoin {
        name = "opencode";
        paths = [ pkgs.opencode ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/opencode \
            --set OPENCODE_ENABLE_EXA 1 \
            --set OPENCODE_EXPERIMENTAL_LSP_TOOL "true" \
            --set OPENCODE_EXPERIMENTAL_WORKSPACES "true"
        '';
      };
    in
    {
      # Other Interesting Plugins
      # - opencode-background-agents (seems a bit overkill)
      # - open-ralph-wiggum
      # - opencode-dynamic-context-pruning (useful with token-based plan)
      programs.opencode = {
        enable = true;
        enableMcpIntegration = true;
        package = wrappedOpencode;
        settings = {
          autoupdate = false;
        };
        tui = {
          attention = {
            enabled = true;
            notifications = true;
            sound = false;
          };
        };
        extraPackages = config.my.dev.lsp;
      };

      # https://www.reddit.com/r/opencodeCLI/comments/1rnenp4/comment/oaoses3
      home.file.".config/opencode/AGENTS.md".text = ''
        ### Session Start

        Read in this exact order:
        1. `README.md`
        2. `docs/HANDOFF.md`
        3. latest entry in `docs/SESSION_LOG.md`
        4. `docs/DECISIONS.md`
        5. `docs/RUNBOOK.md`

        ### During Work

        - Keep `docs/HANDOFF.md` aligned with current status and next actions.
        - Record durable decisions in `docs/DECISIONS.md`.
        - Keep operational command changes in `docs/RUNBOOK.md`.

        ### Session End

        - Update `docs/HANDOFF.md`:
          - `Last updated` timestamp (`YYYY-MM-DD HH:MM UTC`)
          - current state
          - top 3 next actions
          - blockers (if any)
        - Append a new timestamped entry to `docs/SESSION_LOG.md`.
      '';
    };
}
