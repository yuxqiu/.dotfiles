{
  flake.modules.homeManager.markdown =
    { pkgs, ... }:
    {
      my.dev.languages.markdown = {
        lsp = [ pkgs.markdown-oxide ];
        formatter = pkgs.prettier;
      };
    };
}
