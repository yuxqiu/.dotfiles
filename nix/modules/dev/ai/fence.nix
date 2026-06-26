{
  flake.modules.homeManager.fence =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ fence ];

      xdg.configFile."fence/fence.json".text = builtins.toJSON {
        extends = "code-relaxed";
      };
    };
}
