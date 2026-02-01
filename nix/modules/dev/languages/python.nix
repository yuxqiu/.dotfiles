{
  flake.modules.homeManager.base =
    { config, ... }:
    {
      home.file.".pythonrc".text = ''
        # enable syntax completion
        try:
            import readline
        except ImportError:
            ...
        else:
            import rlcompleter
            readline.parse_and_bind("tab: complete")
      '';

      home.sessionVariables = {
        # Python auto-complete
        PYTHONSTARTUP = "${config.home.homeDirectory}/.pythonrc";
      };
    };
}
