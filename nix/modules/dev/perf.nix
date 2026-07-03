{
  flake.modules.homeManager.hyperfine = { pkgs, ... }: {
    home.packages = with pkgs; [ hyperfine ];
  };

  flake.modules.homeManager.poop = { pkgs, ... }: {
    home.packages = with pkgs; [ poop ];
  };
}
