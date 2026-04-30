{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ ollama ];

      services.ollama = {
        enable = true;
      };
    };
}
