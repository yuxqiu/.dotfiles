{ config, ... }:
{
  home.sessionVariables = {
    # Python auto-complete
    PYTHONSTARTUP = "${config.home.homeDirectory}/.pythonrc";

    # Do Not Track
    DO_NOT_TRACK = "1";
  };

  # Extend PATH
  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
  ];
}
