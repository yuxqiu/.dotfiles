{
  flake.modules.homeManager.entire =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.entire ];

      programs.zsh.shellAliases = {
        # Enable entire in a repo with telemetry and auto-push disabled
        "entire-enable" = "entire enable --telemetry=false --skip-push-sessions";
        # Update existing repo settings to disable telemetry and auto-push
        "entire-configure-privacy" = "entire configure --telemetry=false --skip-push-sessions";
      };
    };
}
