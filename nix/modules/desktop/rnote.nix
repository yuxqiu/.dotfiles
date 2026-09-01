{
  flake.modules.homeManager.rnote =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        rnote
      ];
    };
}
