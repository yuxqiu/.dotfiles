{
  flake.modules.homeManager.base = {
    programs.codex = {
      enable = true;
      settings = {
        analytics.enabled = false;
        web_search = "live";
      };
    };

    programs.gemini-cli = {
      enable = true;
      settings = {
        privacy.usageStatisticsEnabled = false;
        security.auth.selectedType = "oauth-personal";
      };
    };

    programs.opencode = {
      enable = true;
      settings = {
        autoupdate = false;
      };
    };
  };

  flake.modules.systemManager.base =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.my.sops.enable (
        let
          geminicommitWithConfig = pkgs.symlinkJoin {
            name = "geminicommit";
            paths = [ pkgs.geminicommit ];
            buildInputs = [ pkgs.makeWrapper ];
            postBuild = ''
              wrapProgram "$out/bin/geminicommit" \
                --add-flags "--config ${config.sops.secrets."geminicommit.toml".path}"
            '';
          };
        in
        {
          users.groups.geminicommit = { };
          users.users.geminicommit = {
            isSystemUser = true;
            group = "geminicommit";
            home = "/var/lib/geminicommit";
            createHome = true;
            description = "geminicommit service user";
          };

          sops.secrets."geminicommit.toml" = {
            mode = "0440";
            owner = config.users.users.geminicommit.name;
            group = config.users.users.geminicommit.group;
          };

          environment.systemPackages = [
            geminicommitWithConfig
          ];
        }
      );
    };
}
