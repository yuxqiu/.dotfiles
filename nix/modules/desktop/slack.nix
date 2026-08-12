{
  flake.modules.homeManager.slack =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ slack ];
    };
}
