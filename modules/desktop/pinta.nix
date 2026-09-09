{
  flake.modules.homeManager.pinta =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        pinta
      ];
    };
}
