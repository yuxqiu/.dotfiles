{
  flake.modules.homeManager.bash-lang =
    { pkgs, ... }:
    {
      my.dev.languages.bash = {
        lsp = [
          {
            server = "bashls";
            package = pkgs.bash-language-server;
            binary = "bash-language-server";
            extraArgs = [ "start" ];
            filetypes = [ "bash" "sh" ];
          }
        ];
        linter = [
          {
            name = "shellcheck";
            package = pkgs.shellcheck;
            filetypes = [ "bash" "sh" ];
          }
        ];
        treesitter = [ "bash" ];
      };
    };
}
