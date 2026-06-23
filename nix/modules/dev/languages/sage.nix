{
  flake.modules.homeManager.sage =
    { pkgs, ... }:
    {
      my.dev.languages.sage = {
        toolchain = [ pkgs.sage ];
      };
    };
}
