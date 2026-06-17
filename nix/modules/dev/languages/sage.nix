{
  flake.modules.homeManager.sage =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ sage ];
    };
}
