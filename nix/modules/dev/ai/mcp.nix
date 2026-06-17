{
  flake.modules.homeManager.ai = { pkgs, ... }: {
    programs.mcp = {
      enable = true;
    };

    home.packages = with pkgs; [ mcp-nixos ];
  };
}
