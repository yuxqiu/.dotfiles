{
  flake.modules.homeManager.codex =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      configPath = ".codex/config.toml";
    in
    {
      programs = {
        codex = {
          enable = true;
          enableMcpIntegration = true;
          settings = {
            analytics.enabled = false;
            web_search = "live";
            tui = {
              status_line = [
                "model-with-reasoning"
                "context-used"
                "five-hour-limit"
                "weekly-limit"
                "approval-mode"
              ];
              status_line_use_colors = true;
            };
          };
          # Ingest the shared AGENTS.md content as Codex's global AGENTS.md.
          context = config.my.agents-md.content;
        };

        agent-skills.targets.codex.enable = true;
      };

      # home-manager symlinks config.toml read-only into /nix/store, but Codex
      # writes trust_level entries into it when a directory is trusted in the
      # TUI, which fails against a read-only store path. Disable that
      # management and merge the nix-generated settings into a writable copy
      # on activation instead.
      # https://github.com/nix-community/home-manager/issues/9397
      # Adapted from https://github.com/holidayworking/core/pull/433/files
      home.file.${configPath}.enable = false;

      home.activation.codexMutableConfig = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
        configFile=${lib.escapeShellArg "${config.home.homeDirectory}/${configPath}"}
        staticConfig=${lib.escapeShellArg config.home.file.${configPath}.source}

        # Carry over Codex-written entries from the previous writable copy;
        # a symlink left by an older generation has nothing worth keeping.
        existingConfig=/dev/null
        if [ -f "$configFile" ] && [ ! -L "$configFile" ]; then
          existingConfig="$configFile"
        fi

        mergedConfig="$(mktemp)"
        ${lib.getExe pkgs.yq-go} -p toml -o toml eval-all \
          '. as $item ireduce ({}; . * $item)' \
          "$existingConfig" "$staticConfig" > "$mergedConfig"
        install -Dm644 "$mergedConfig" "$configFile"
        rm -f "$mergedConfig"
      '';
    };
}
