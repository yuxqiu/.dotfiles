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
            --set OPENCODE_EXPERIMENTAL_LSP_TOOL "true"
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
          plugin = [
            "@mohak34/opencode-notifier"
            "opencode-worktree"
          ];
        };
        extraPackages = config.my.dev.lsp;
      };

      # opencode-notifier
      home.file.".config/opencode/opencode-notifier.json".text = builtins.toJSON {
        sound = false;
        notification = true;
        bell = false;
        timeout = 5;
        showProjectName = true;
        showSessionTitle = false;
        showIcon = true;
        customIconPath = null;
        suppressWhenFocused = true;
        enableOnDesktop = false;
        notificationSystem = "osascript";
        linux = {
          grouping = false;
        };
        minDuration = 0;
        command = {
          enabled = false;
          path = "/path/to/command";
          args = [
            "--event"
            "{event}"
            "--message"
            "{message}"
          ];
          minDuration = 0;
        };
        events = {
          permission = {
            sound = true;
            notification = true;
            command = true;
            bell = false;
          };
          complete = {
            sound = true;
            notification = true;
            command = true;
            bell = false;
          };
          subagent_complete = {
            sound = false;
            notification = false;
            command = true;
            bell = false;
          };
          error = {
            sound = true;
            notification = true;
            command = true;
            bell = false;
          };
          question = {
            sound = true;
            notification = true;
            command = true;
            bell = false;
          };
          user_cancelled = {
            sound = false;
            notification = false;
            command = true;
            bell = false;
          };
          plan_exit = {
            sound = true;
            notification = true;
            command = true;
            bell = false;
          };
          session_started = {
            sound = true;
            notification = false;
            command = true;
            bell = false;
          };
          user_message = {
            sound = true;
            notification = false;
            command = true;
            bell = false;
          };
          client_connected = {
            sound = true;
            notification = false;
            command = true;
            bell = false;
          };
        };
        messages = {
          permission = "Session needs permission: {sessionTitle}";
          complete = "Session has finished: {sessionTitle}";
          subagent_complete = "Subagent task completed: {sessionTitle}";
          error = "Session encountered an error: {sessionTitle}";
          question = "Session has a question: {sessionTitle}";
          user_cancelled = "Session was cancelled by user: {sessionTitle}";
          plan_exit = "Plan ready for review: {sessionTitle}";
          session_started = "Session started: {sessionTitle}";
          user_message = "User sent a message: {sessionTitle}";
          client_connected = "OpenCode connected";
        };
        sounds = {
          permission = null;
          complete = null;
          subagent_complete = null;
          error = null;
          question = null;
          user_cancelled = null;
          plan_exit = null;
          session_started = null;
          user_message = null;
          client_connected = null;
        };
        volumes = {
          permission = 1;
          complete = 1;
          subagent_complete = 1;
          error = 1;
          question = 1;
          user_cancelled = 1;
          plan_exit = 1;
          session_started = 1;
          user_message = 1;
          client_connected = 1;
        };
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
