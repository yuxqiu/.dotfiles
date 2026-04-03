{
  flake.modules.homeManager.linux-desktop =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ idescriptor ];
    };
}
