{
  flake.modules.homeManager.linux-gui =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ idescriptor ];
    };
}
