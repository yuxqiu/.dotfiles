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

      subtask2 = pkgs.callPackage (inputs.self + /packages/subtask2.nix) { };
      btwOpencode = pkgs.callPackage (inputs.self + /packages/btw-opencode.nix) { };
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

      # subtask2 plugin - installed as a local opencode plugin
      # https://github.com/spoons-and-mirrors/subtask2
      # https://opencode.ai/docs/plugins/#from-local-files
      home.file.".config/opencode/plugins/subtask2.js".source = "${subtask2}/lib/subtask2/index.js";

      # handoff plugin - installed as a local opencode plugin
      # https://github.com/joshuadavidthomas/opencode-handoff
      home.file.".config/opencode/plugins/handoff.js".source =
        "${handoff}/lib/opencode-handoff/plugin.js";

      # btw-opencode plugin - fork sessions and run prompts in background
      # https://github.com/aptdnfapt/btw-opencode
      home.file.".config/opencode/plugins/btw-opencode.js".source =
        "${btwOpencode}/lib/btw-opencode/btw-opencode.js";

      # /s2 command plugin - local .ts file, loaded directly by opencode/bun
      home.file.".config/opencode/plugins/subtask2-commands.ts".source =
        ./extensions/subtask2-commands.ts;
    };
}
