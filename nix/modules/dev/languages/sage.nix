{
  flake.modules.homeManager.rust =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ sage ];
    };
}
