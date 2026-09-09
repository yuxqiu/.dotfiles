{
  flake.modules.homeManager.jan = { pkgs, ... }: {
    home.packages = with pkgs; [ jan ];
  };
}
