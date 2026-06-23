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
        toolchain = with pkgs; [ uv python3 ];
        lsp = [
          {
            server = "basedpyright";
            package = pkgs.basedpyright;
            binary = "basedpyright-langserver";
            extraArgs = [ "--stdio" ];
            filetypes = [ "python" ];
          }
        ];
        formatter = {
          cmd = "ruff";
          package = pkgs.ruff;
          filetypes = [ "python" ];
        };
        linter = [
          {
            name = "ruff";
            package = pkgs.ruff;
            filetypes = [ "python" ];
          }
        ];
        treesitter = [ "python" ];
      };
    };
}
