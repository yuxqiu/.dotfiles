{
  flake.modules.homeManager.nixpkgs-track =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ nixpkgs-track ];
    };
}
