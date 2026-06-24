{
  flake.modules.homeManager.python =
    { pkgs, config, ... }:
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
        PYTHONSTARTUP = "${config.home.homeDirectory}/.pythonrc";
      };

      my.dev.languages.python = {
        toolchain = with pkgs; [
          uv
          python3
        ];
        lsp = [ pkgs.basedpyright ];
        formatter = pkgs.ruff;
        linter = [ pkgs.ruff ];
      };
    };
}
