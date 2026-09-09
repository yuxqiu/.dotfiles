{
  flake.modules.homeManager.idescriptor =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ idescriptor ];
    };
}
