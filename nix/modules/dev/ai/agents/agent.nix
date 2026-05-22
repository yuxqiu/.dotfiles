let
  agentsMd = ''
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
in
{
  flake.modules.homeManager.ai = {
    home.file.".config/opencode/AGENTS.md".text = agentsMd;
    home.file.".omp/agent/AGENTS.md".text = agentsMd;
  };
}