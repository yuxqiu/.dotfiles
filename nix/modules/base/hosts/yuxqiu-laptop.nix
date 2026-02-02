{
  config,
  ...
}:

{
  configurations.homeManager = {
    "yuxqiu-laptop" = {
      system = "aarch64-linux";
      stateVersion = "26.05";
      modules = [
        config.flake.modules.homeManager.base
        config.flake.modules.homeManager.gui
        config.flake.modules.homeManager.linux-base
        config.flake.modules.homeManager.linux-gui

        config.flake.modules.homeManager.yuxqiu
      ];
    };
  };

  configurations.systemManager = {
    "yuxqiu-laptop" = {
      system = "aarch64-linux";
      modules = [
        config.flake.modules.systemManager.base
        config.flake.modules.systemManager.gui

        config.flake.modules.systemManager.nixbld
        config.flake.modules.systemManager.yuxqiu
      ];
    };
  };
}
