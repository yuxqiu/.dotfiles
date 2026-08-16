{
  flake.modules.homeManager.proton-vpn = { pkgs, ... }: {
    home.packages = with pkgs; [ proton-vpn ];
  };
}
