{
  flake.modules.homeManager.bash-lang =
    { pkgs, ... }:
    {
      my.dev.languages.bash = {
        lsp = [ pkgs.bash-language-server ];
        formatter = pkgs.shfmt;
        linter = [ pkgs.shellcheck ];
      };
    };
}
