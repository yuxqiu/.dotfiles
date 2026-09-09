{
  flake.modules.homeManager.zoom =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ zoom-us ];
    };
}
