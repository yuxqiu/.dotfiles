{ inputs, ... }:
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

      opencodeQueue = pkgs.callPackage (inputs.self + /packages/opencode-queue.nix) { };
      goalPlugin = pkgs.callPackage (inputs.self + /packages/opencode-goal.nix) { };
      btwOpencode = pkgs.callPackage (inputs.self + /packages/opencode-btw.nix) { };
      handoff = pkgs.callPackage (inputs.self + /packages/opencode-handoff.nix) { };
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
          command = {
            goal = {
              description = "Set a session-scoped goal and auto-continue until complete.";
              template = "$ARGUMENTS";
              agent = "build";
            };
          };
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

      # opencode-queue plugin - queue input until session is idle
      # https://github.com/mirsella/opencode-queue
      home.file.".config/opencode/plugins/opencode-queue.js".source =
        "${opencodeQueue}/lib/opencode-queue/index.js";

      # opencode-goal-plugin - session-scoped /goal workflow
      # https://github.com/willytop8/OpenCode-goal-plugin
      home.file.".config/opencode/plugins/opencode-goal.js".source =
        "${goalPlugin}/lib/opencode-goal-plugin/goal-plugin.js";

      # handoff plugin - installed as a local opencode plugin
      # https://github.com/joshuadavidthomas/opencode-handoff
      home.file.".config/opencode/plugins/handoff.js".source =
        "${handoff}/lib/opencode-handoff/plugin.js";

      # btw-opencode plugin - fork sessions and run prompts in background
      # https://github.com/aptdnfapt/btw-opencode
      home.file.".config/opencode/plugins/btw-opencode.js".source =
        "${btwOpencode}/lib/btw-opencode/btw-opencode.js";
    };
}
