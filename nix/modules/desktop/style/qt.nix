{
  flake.modules.homeManager.qt =
    { pkgs, ... }:
    {
      qt = {
        enable = true;
        platformTheme.name = "qtct";
        style.name = "kvantum";
      };

      stylix.targets.qt.enable = true;
    };
}
