{
  flake.modules.homeManager.hydra-check =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ hydra-check ];
    };
}
