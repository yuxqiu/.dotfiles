{
  flake.modules.homeManager.distrobox =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        distrobox
        distroshelf
      ];
    };
}
