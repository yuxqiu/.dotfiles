{
  flake.modules.homeManager.linux-base =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        distrobox
        distroshelf
      ];
    };
}
