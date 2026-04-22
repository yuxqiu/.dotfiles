{
  flake.modules.homeManager.base =
    { config, ... }:
    {
      # Other Interesting Plugins
      # - opencode-background-agents (seems a bit overkill)
      # - open-ralph-wiggum
      # - opencode-dynamic-context-pruning (useful with token-based plan)
      programs.opencode = {
        enable = true;
        enableMcpIntegration = true;
        settings = {
          autoupdate = false;
          plugin = [
            "opencode-notifier"
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
        suppressWhenFocused = true;
        enableOnDesktop = false;
        notificationSystem = "osascript";
        linux = {
          grouping = false;
        };
      };
    };
}
