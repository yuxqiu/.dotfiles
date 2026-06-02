{
  flake.modules.nixos.geminicli =
    {
      config,
      pkgs,
      ...
    }:
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
    };
}
