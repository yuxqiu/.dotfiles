{
  flake.modules.homeManager.session =
    { config, ... }:
    {
      home.sessionVariables = {
        # Do Not Track
        DO_NOT_TRACK = "1";
      };

      # Extend PATH
      home.sessionPath = [
        "${config.home.homeDirectory}/.local/bin"
      ];
    };
}
